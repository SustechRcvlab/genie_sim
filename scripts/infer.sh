docker exec -it genie_sim_benchmark_axgu bash -ic "\
cd AgiBot-World && \
cd RDT && \
omni_python ./scripts/infer.py --task_name=iros_pack_in_the_supermarket"
