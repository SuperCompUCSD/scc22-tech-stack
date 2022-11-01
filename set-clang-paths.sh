#!/bin/bash -e
source /etc/profile
if ! [[ -e /opt/AMD/aocc-compiler-3.0.0 ]]; then
  >&2 echo "error: aocc 3.0.0 not installed"
  exit 1
fi
LIBCPP='/usr/lib/libstdc++.so'
OSVER=$(grep VERSION_ID /etc/os-release | cut -d'"' -f 2)
if [[  $OSVER == "22.04" ]]; then
  # If $LIBCPP not found, symlink it
  if ! [[ -e "$LIBCPP" ]]; then
    ln -s /usr/lib/gcc/x86_64-linux-gnu/11/libstdc++.so "$LIBCPP"
  fi
  # Modify the c++ include path for clang to find standard library
  if [[ $CPLUS_INCLUDE_PATH != *"/usr/include/x86_64-linux-gnu/c++/11"* ]]; then
    export CPLUS_INCLUDE_PATH="/usr/include/x86_64-linux-gnu/c++/11:$CPLUS_INCLUDE_PATH"
    echo 'export CPLUS_INCLUDE_PATH="/usr/include/x86_64-linux-gnu/c++/11:$CPLUS_INCLUDE_PATH"' >> /etc/profile
  fi
  if [[ $CPLUS_INCLUDE_PATH != *"/usr/include/c++/11"* ]]; then
    export CPLUS_INCLUDE_PATH="/usr/include/c++/11:$CPLUS_INCLUDE_PATH"
    echo 'export CPLUS_INCLUDE_PATH="/usr/include/c++/11:$CPLUS_INCLUDE_PATH"' >> /etc/profile
  fi
elif [[ $OSVER == "20.04" ]]; then
  # If $LIBCPP not found, symlink it
  if ! [[ -e "$LIBCPP" ]]; then
    ln -s /usr/lib/gcc/x86_64-linux-gnu/9/libstdc++.so "$LIBCPP"
  fi
  # Modify the c++ include path for clang to find standard library
  echo "$CPLUS_INCLUDE_PATH"
  if [[ $CPLUS_INCLUDE_PATH != *"/usr/include/x86_64-linux-gnu/c++/9"* ]]; then
    echo "modifying path 1"
    export CPLUS_INCLUDE_PATH="/usr/include/x86_64-linux-gnu/c++/9:$CPLUS_INCLUDE_PATH"
    echo 'export CPLUS_INCLUDE_PATH="/usr/include/x86_64-linux-gnu/c++/9:$CPLUS_INCLUDE_PATH"' >> /etc/profile
  fi
  if [[ $CPLUS_INCLUDE_PATH != *"/usr/include/c++/9"* ]]; then
    echo "modifying path 2"
    export CPLUS_INCLUDE_PATH="/usr/include/c++/9:$CPLUS_INCLUDE_PATH"
    echo 'export CPLUS_INCLUDE_PATH="/usr/include/c++/9:$CPLUS_INCLUDE_PATH"' >> /etc/profile
  fi
else 
  >&2 echo "error: os not recognized"
  exit 1
fi
