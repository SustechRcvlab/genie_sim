#!/bin/bash
set -eo pipefail

# default assest path ,only use not declare SIM_ASSETS in env
DEFAULT_SIM_ASSETS="/data/axgu/assest/GenieSimAssets/"
SIM_ASSETS="${SIM_ASSETS:-$DEFAULT_SIM_ASSETS}"
CURRENT_DIR=$(pwd)

echo "using SIM_REPO_ROOT='$CURRENT_DIR'"
echo "using SIM_ASSETS='$SIM_ASSETS'"

# 路径合法性检测（可选）
if [ ! -d "$SIM_ASSETS" ]; then
    echo "Error: SIM_ASSETS directory does not exist: $SIM_ASSETS"
    exit 1
fi

docker run -itd --name genie_sim_benchmark \
    --entrypoint ./scripts/entrypoint.sh \
    --gpus all \
    --rm \
    --network=host \
    --privileged \
    -e "SIM_ASSETS=$SIM_ASSETS" \
    -e "ACCEPT_EULA=Y" \
    -e "PRIVACY_CONSENT=Y" \
    -e "PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=python" \
    -v ~/docker/isaac-sim/cache/kit:/isaac-sim/kit/cache:rw \
    -v ~/docker/isaac-sim/cache/ov:/root/.cache/ov:rw \
    -v ~/docker/isaac-sim/cache/pip:/root/.cache/pip:rw \
    -v ~/docker/isaac-sim/cache/glcache:/root/.cache/nvidia/GLCache:rw \
    -v ~/docker/isaac-sim/cache/computecache:/root/.nv/ComputeCache:rw \
    -v ~/docker/isaac-sim/logs:/root/.nvidia-omniverse/logs:rw \
    -v ~/docker/isaac-sim/data:/root/.local/share/ov/data:rw \
    -v ~/docker/isaac-sim/documents:/root/Documents:rw \
    -v $SIM_ASSETS:/root/assets:rw \
    -v $CURRENT_DIR:/root/workspace/main:rw \
    -w /root/workspace/main \
    genie-sim:v2
