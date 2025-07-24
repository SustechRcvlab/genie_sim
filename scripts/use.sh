omni_python server/source/genie.sim.lab/raise_standalone_sim.py \
    --enable_curobo True \
    --headless \
    --livestream 2

omni_python benchmark/task_benchmark.py \
    --task_name=curobo_restock_supermarket_items \
    --env_class=DemoEnv 
