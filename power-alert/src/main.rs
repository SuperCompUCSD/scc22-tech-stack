use std::{process::Command, thread, time::Duration};

use chrono::{Local, NaiveDateTime, TimeZone, Utc};
use serde::Deserialize;

#[derive(Deserialize)]
#[serde(rename_all = "PascalCase")]
struct Limit {
	valid_until: String,
	cap_watts: String,
	known_events: Vec<Events>,
}

#[derive(Deserialize)]
#[serde(rename_all = "PascalCase")]
struct Events {
	event: String,
	start_time: String,
	cap_watts: u16,
}

fn main() {
	loop {
		let limit_json = ureq::get("http://140.221.235.227").call();
		let Ok(body) = limit_json else {
			eprintln!("Warning: power limit request failed");
			continue;
		};
		let power = Command::new("snmpwalk")
			.args([
				"-v2c",
				"-c",
				"public",
				"140.221.235.139",
				".1.3.6.1.4.1.21239.5.2.3.1.1.10.1",
			])
			.output();
		let Ok(power) = power else {
			eprintln!("Warning: current power request failed");
			continue;
		};
		if !power.status.success() {
			eprintln!("Warning: current power request failed: exit failure");
			continue;
		}
		let Ok(line) = String::from_utf8(power.stdout) else {
			eprintln!("Warning: current power output is not valid UTF-8");
			continue;
		};
		let Some(power) = line.strip_prefix("iso.3.6.1.4.1.21239.5.2.3.1.1.10.1 = Gauge32: ") else {
			eprintln!("Warning: stripping power output prefix failed");
			continue;
		};
		let Some(power) = power.strip_suffix("\n") else {
			eprintln!("Warning: stripping power output suffix failed");
			continue;
		};
		let limit: Limit = body.into_json().unwrap();

		let Ok(mut power): Result<u16, _> = power.parse() else {
			eprintln!("Warning: parsing crurrent power failed");
			continue;
		};
		let Ok(current_limit): Result<u16, _> = limit.cap_watts.parse() else {
			eprintln!("Warning: parsing crurrent limit failed");
			continue;
		};
		println!(
			"--- Time: {} ---\nPower = {}, Current limit = {}, Valid until = {}",
			Local::now().to_rfc2822(),
			power,
			current_limit,
			limit.valid_until
		);
		for (i, event) in limit.known_events.iter().enumerate() {
			let Some(time) = event.start_time.strip_suffix("Z") else {
				eprintln!("Warning: parsing event limit failed");
				continue;
			};
			let Ok(time) = NaiveDateTime::parse_from_str(&time, "%Y%m%dT%H%M%S") else {
				eprintln!("Warning: parsing event limit failed");
				continue;
			};
			let Ok(duration) = (time - Utc::now().naive_utc()).to_std() else {
				eprintln!("Warning: failed to find time until");
				continue;
			};
			let seconds = duration.as_secs() % 60;
			let minutes = (duration.as_secs() / 60) % 60;
			let hours = (duration.as_secs() / 60) / 60;
			let until = format!("{:02}:{:02}:{:02}", hours, minutes, seconds);
			println!(
				"Event #{}: {}W starting at {} ({} left): {}",
				i + 1,
				event.cap_watts,
				Local.from_utc_datetime(&time).to_rfc2822(),
				until,
				event.event,
			);
		}
		println!();
		while power > current_limit - 400 {
			power -= 100;
			let Ok(status) = Command::new("quack").status() else {
				eprintln!("Warning: failed to quack");
				continue;
			};
			if !status.success() {
				eprintln!("Warning: failed to quack");
				continue;
			}
		}
		thread::sleep(Duration::from_secs(5));
	}
}
