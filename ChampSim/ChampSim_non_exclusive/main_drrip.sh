#! /bin/sh


./build_champsim.sh bimodal no no no no drrip 1


./run_champsim.sh bimodal-no-no-no-no-drrip-1core 30 60 pr-3.trace.gz
./run_champsim.sh bimodal-no-no-no-no-drrip-1core 30 60 sssp-3.trace.gz
./run_champsim.sh bimodal-no-no-no-no-drrip-1core 30 60 bfs-10.trace.gz