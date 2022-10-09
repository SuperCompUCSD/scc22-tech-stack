use std::{
	io,
	process::{self, ExitStatus},
	thread,
	time::Duration,
};

use anyhow::{bail, Context};
use clap::Parser;

#[derive(Parser)]
#[command(author, version, about)]
struct Args {
	/// Temperature to trigger the shutdown
	#[arg(short, long)]
	trigger: i32,
	/// Minutes between each temperature check
	#[arg(short, long)]
	interval: u64,
	/// Minutes before shutdown after warning with `wall`
	#[arg(short, long)]
	grace: u64,
}

fn main() -> anyhow::Result<()> {
	let args = Args::parse();
	let interval_secs = args
		.interval
		.checked_mul(60)
		.context("interval overflows as seconds")?;
	let mut scheduled = false;

	loop {
		match check_temp() {
			Ok(temp) => {
				if temp >= args.trigger && !scheduled {
					let warning = &format!(
						"Inlet (room) temperature reached {temp} C!  \
						To stop monitoring, run \"systemctl stop high-temp-auto-shutdown\".",
					);
					match handle_status(process::Command::new("wall").args([warning]).status()) {
						Ok(()) => eprintln!("Announcement sent"),
						Err(e) => eprintln!("Failed to send announcement: {e}"),
					}
					match handle_status(
						process::Command::new("shutdown")
							.args([&format!("+{}", args.grace), warning])
							.status(),
					) {
						Ok(()) => {
							eprintln!("Shutdown scheduled");
							scheduled = true;
						}
						Err(e) => eprintln!("Failed to schedule shutdown: {e}"),
					}
				} else if temp < args.trigger {
					eprintln!("Temperature okay: {temp} C");
					if scheduled {
						scheduled = false;
						match handle_status(process::Command::new("shutdown").args(["-c"]).status())
						{
							Ok(()) => eprintln!("Shutdown cancelled"),
							Err(e) => eprintln!("Failed to cancel shutdown: {e}"),
						}
					}
				} else {
					eprintln!("Temperature over limit, shutdown scheduled: {temp} C");
				}
			}
			Err(e) => eprintln!("Failed to check temperature: {:#}", e),
		}
		thread::sleep(Duration::from_secs(interval_secs));
	}
}

fn check_temp() -> Result<i32, anyhow::Error> {
	let output = process::Command::new("ipmitool")
		.args(["-c", "sensor", "reading", "Inlet Temp"])
		.output()
		.context("running ipmitool command failed")?;
	if !output.status.success() {
		let args = match output.status.code() {
			Some(code) => format!("failed with exit code {code}"),
			None => "failed, exit code not available (terminated by a signal?)".to_owned(),
		};
		bail!(format!(
			"ipmitool command {args}:\n--- stdout ---\n{}--- stderr ---\n{}",
			String::from_utf8_lossy(&output.stdout),
			String::from_utf8_lossy(&output.stderr),
		)
		.trim_end()
		.to_owned())
	}
	if !output.stderr.is_empty() {
		bail!(
			"stderr not empty: {}",
			String::from_utf8_lossy(&output.stderr)
		)
	};
	let output = std::str::from_utf8(&output.stdout)
		.with_context(|| {
			format!(
				"failed to parse ipmitool output as UTF-8: {}",
				String::from_utf8_lossy(&output.stdout)
			)
		})?
		.trim_end();
	let temp_str = output.strip_prefix("Inlet Temp,").with_context(|| {
		format!("failed to strip prefix from ipmitool command output: {output}")
	})?;
	let temp = temp_str
		.parse()
		.with_context(|| format!("failed to parse ipmitool output to string: {temp_str}"))?;
	Ok(temp)
}

fn handle_status(status: Result<ExitStatus, io::Error>) -> Result<(), String> {
	match status {
		Ok(status) if status.success() => Ok(()),
		Ok(status) => match status.code() {
			Some(code) => Err(format!("exit code {code}")),
			None => Err(format!("exit code not available (terminated by a signal?)")),
		},
		Err(e) => Err(e.to_string()),
	}
}
