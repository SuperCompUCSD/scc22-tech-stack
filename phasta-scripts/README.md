# Scripts for Compiling and Running PHASTA on Neil

## Compile 
```
. compile-phasta.sh
```
This script will check if gmsh is installed and install it if not. After, you will be prompted to press 1 if you want to compile PHASTA with the PETSC solver and 0 if you want to compile PHASTA with just the native solver. After PHASTA has been build you will again prompted to enter 1 if you would like to install the phastaChefTests and 0 if not.


## Run
```
. run-phasta.sh <num_cores>
```
