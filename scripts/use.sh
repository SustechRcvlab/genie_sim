omni_python server/source/genie.sim.lab/raise_standalone_sim.py \
    --headless \
    --livestream 2


cd AgiBot-World && cd RDT &&
omni_python ./scripts/infer.py --task_name=iros_clear_table_in_the_restaurant

run_client iros_clear_table_in_the_restaurant




