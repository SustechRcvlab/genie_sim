#!/bin/bash
set -eo pipefail

# default assest path ,only use not declare SIM_ASSETS in env
DEFAULT_SIM_ASSETS="/data/blzou/genie_sim/GenieSimAssets/"
SIM_ASSETS="${SIM_ASSETS:-$DEFAULT_SIM_ASSETS}"
CURRENT_DIR=$(pwd)

echo "using SIM_REPO_ROOT='$CURRENT_DIR'"
echo "using SIM_ASSETS='$SIM_ASSETS'"

# 路径合法性检测（可选）
if [ ! -d "$SIM_ASSETS" ]; then
    echo "Error: SIM_ASSETS directory does not exist: $SIM_ASSETS"
    exit 1
fi

# 用于不同的Webrtc映射
NETWORK_USE=isaac
# 需要预先设置过网络  docker network create --subnet=172.18.0.0/16 isaac
USE_IP=172.18.0.10 
# WEBRTC_PORT=8211
WEBRTC_PORT_EXPORT=8212
    # --net $NETWORK_USE --ip $USE_IP -p $WEBRTC_PORT_EXPORT:8211 \
# 10.16.118.8:8212
docker run -itd --name genie_sim_benchmark_axgu \
    --entrypoint ./scripts/entrypoint.sh \
    --gpus all \
    --rm \
    --net host \
    --privileged \
    -e "SIM_ASSETS=$SIM_ASSETS" \
    -e "ACCEPT_EULA=Y" \
    -e "PRIVACY_CONSENT=Y" \
    -e "PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=python" \
    -v "$HOME/docker/isaac-sim/cache/kit:/isaac-sim/kit/cache:rw" \
    -v "$HOME/docker/isaac-sim/cache/ov:/root/.cache/ov:rw" \
    -v "$HOME/docker/isaac-sim/cache/pip:/root/.cache/pip:rw" \
    -v "$HOME/docker/isaac-sim/cache/glcache:/root/.cache/nvidia/GLCache:rw" \
    -v "$HOME/docker/isaac-sim/cache/computecache:/root/.nv/ComputeCache:rw" \
    -v "$HOME/docker/isaac-sim/logs:/root/.nvidia-omniverse/logs:rw" \
    -v "$HOME/docker/isaac-sim/data:/root/.local/share/ov/data:rw" \
    -v "$HOME/docker/isaac-sim/documents:/root/Documents:rw" \
    -v $SIM_ASSETS:/root/assets:rw \
    -v $CURRENT_DIR:/root/workspace/main:rw \
    -w /root/workspace/main \
    genie-sim:v2
