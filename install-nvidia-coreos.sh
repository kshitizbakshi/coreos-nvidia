#!/bin/bash

#Check if we even have an NVIDIA GPU. If not, exit without triggering failure.
if [[ $(lspci | grep -i nvidia) ]];
then
        echo "NVIDIA GPU Found!";
else
        echo "No NVIDIA GPU. Exiting.";
        exit 0;
fi

set -e

/bin/bash build.sh $1 $2 $3
echo "NVIDIA Drivers built! Trying to install now...\n";
/bin/bash nvidia_install.sh $1 $2 $3
echo "NVIDIA Drivers installed!\n"