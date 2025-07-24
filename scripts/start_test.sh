docker run -it --rm \
  --name genie_sim_benchmark \
  --gpus all \
  --network=host \
  --env "ACCEPT_EULA=Y" \
  --env "DISPLAY=" \
  --env "ENABLE_HEADLESS=1" \
  --env "ISAAC_HEADLESS=1" \
  --env "NVIDIA_VISIBLE_DEVICES=all" \
  --env "NVIDIA_DRIVER_CAPABILITIES=all" \
   -w /root/workspace/main \
  genie-sim:v2 \
  /isaac-sim/isaac-sim.sh --no-window --headless

