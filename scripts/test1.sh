docker run -it --rm \
  --gpus all \
  --network=host \
  --env "ACCEPT_EULA=Y" \
  --env "DISPLAY=" \
  --env "ENABLE_HEADLESS=1" \
  --env "ISAAC_HEADLESS=1" \
  --env "NVIDIA_VISIBLE_DEVICES=all" \
  --env "NVIDIA_DRIVER_CAPABILITIES=all" \
  --volume ${HOME}/.nvidia-omniverse:/root/.nvidia-omniverse \
  --volume $(pwd):/workspace \
  genie-sim:v1 \
  /isaac-sim/isaac-sim.sh --no-window --headless
