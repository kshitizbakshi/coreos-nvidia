#!/bin/sh
set -e

PERSISTENCE_MODE=$(/opt/bin/nvidia-smi --query-gpu=persistence_mode --format=csv | sed -n 2p | awk '{print $1}')
if [ "$PERSISTENCE_MODE" != "Enabled" ]
then
    echo "Setting performance settings requires persistence mode to be enabled. Exiting..."
    exit -1
fi

GPU_CHIP_NAME=$(/opt/bin/nvidia-smi --query-gpu=gpu_name --format=csv | sed -n 2p | awk '{print $2}')
if [ "$GPU_CHIP_NAME" = "V100-SXM2-16GB" ]
then
    echo "Detected a Tesla V100-SXM2-16GB chip. Setting clocks as suggested by AWS Documentation for P3 instances."
    /opt/bin/nvidia-smi -ac 877,1530
else
    #Not a Tesla V100 GPU. Try turning off auto-boost at least, given we don't know max clocks...
    /opt/bin/nvidia-smi --auto-boost-default=0
fi

echo "NVIDIA performance configuration complete."