import os
from isaacsim import SimulationApp

# Set environment variables equivalent to the Docker command
os.environ["ACCEPT_EULA"] = "Y"
os.environ["DISPLAY"] = ""  # Empty for headless mode
os.environ["ENABLE_HEADLESS"] = "1"
os.environ["ISAAC_HEADLESS"] = "1"
os.environ["NVIDIA_VISIBLE_DEVICES"] = "all"
os.environ["NVIDIA_DRIVER_CAPABILITIES"] = "all"

# Ensure Omniverse user directory exists (equivalent to --volume ${HOME}/.nvidia-omniverse:/root/.nvidia-omniverse)
omniverse_user_dir = os.path.expanduser("~/.nvidia-omniverse")
if not os.path.exists(omniverse_user_dir):
    os.makedirs(omniverse_user_dir)

# Set working directory (equivalent to --volume $(pwd):/workspace)
os.chdir(os.getcwd())

# Configure SimulationApp for headless mode
CONFIG = {
    "headless": True,  # Equivalent to --headless and --no-window
    "renderer": "RayTracedLighting",  # Optional: Adjust based on your needs
    "display": False,  # Ensure no display is used
}

# Initialize SimulationApp
try:
    simulation_app = SimulationApp(CONFIG)
    print("Isaac Sim started successfully in headless mode.")

    # Your simulation code goes here
    # Example: Load a USD stage or run a simulation
    # simulation_app.load_usd("/path/to/your_scene.usd")

    # Keep the app running (replace with your simulation loop if needed)
    while simulation_app.is_running():
        simulation_app.update()

    # Cleanup
    simulation_app.close()
    print("Isaac Sim closed successfully.")
except Exception as e:
    print(f"Error starting Isaac Sim: {e}")
    raise
