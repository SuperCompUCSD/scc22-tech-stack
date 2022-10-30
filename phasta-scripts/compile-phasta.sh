#!/bin/bash -e
echo "Checking system for Gmsh..."
GMSH=$(which gmsh)

if [ $GMSH != "/usr/bin/gmsh" ]
then
	echo "Installing GMSH"
	cd
	wget https://gmsh.info/bin/Linux/gmsh-4.10.5-Linux64.tgz
	tar -xvf gmsh-4.10.5-Linux64.tgz
	sudo mv gmsh-4.10.5-Linux64/bin/* /usr/bin/
	sudo mv gmsh-4.10.5-Linux64/share/doc/gmsh /usr/share/doc/
	sudo mv gmsh-4.10.5-Linux64/share/man/man1/gmsh.1 /usr/share/man/man1/
	rm -r gmsh-4.10.5-Linux64
	rm gmsh-4.10.5-Linux64.tgz
	echo "GMSH Installed"
else
	echo "GMSH Already Installed"
fi

cd ~/scc22-scripts/phasta-scripts

echo "Press 1 to Build Phasta with PETSC and 0 to Build Phasta without PETSC"
read PETSC_YES

if [ ${PETSC_YES} == "1" ]
then
	echo "Starting Build for Phasta with PETSC..."
 	./phasta-petsc.sh
else
	echo "Starting Build for Phasta without PETSC..."
        ./phasta-nopetsc.sh
fi
cd ~/scc22-scripts/phasta-scripts
echo "Running script to build Chef..."
# ./chef-install.sh
#echo "Done compiling. Use the run.sh script to run PHASTA"
