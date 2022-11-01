rocminfo && (sudo apt update -y && \
	echo -ne 'adding rocm_gpg' && \
	wget -q -O - https://repo.radeon.com/rocm/rocm.gpg.key | sudo apt-key add - && \
	echo -ne 'adding adding amdgpu to apt' && \
	echo 'deb [arch=amd64] https://repo.radeon.com/amdgpu/latest/ubuntu focal main' | sudo tee /etc/apt/sources.list.d/amdgpu.list && \
	echo 'deb [arch=amd64] https://repo.radeon.com/rocm/apt/debian/ focal main' | sudo tee /etc/apt/sources.list.d/rocm.list && \
	echo -e 'Package: *\nPin: release o=repo.radeon.com\nPin-Priority: 600' | sudo tee /etc/apt/preferences.d/rocm-pin-600 && \
	echo -ne 'updating' && \
	sudo apt-get update -y && \
	echo -ne 'installing rocm and drivers' && \
	sudo apt install -y rocm-hip-sdk rocm-opencl-sdk amdgpu-dkms && \
	echo -ne 'creating rocm_smi' && \
	sudo ln -s /opt/rocm*/libexec/rocm_smi/rocm_smi.py /usr/bin/ && \
	sudo mv /usr/bin/rocm_smi.py /usr/bin/rocm_smi && \
	for ID in $(getent passwd {1000..2000} | awk -F ':' '{ print $1 }') ; do sudo usermod -aG render "$ID"; sudo usermod -aG video "$ID"; done && \
	echo $(tput bold; tput setaf 196)  YOUR\'RE GOING TO NEED TO REBOOT $(tput sgr0)) || \
	echo ROCM is installed
