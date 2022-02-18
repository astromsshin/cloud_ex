#!/bin/bash

# without map-by
time mpirun --allow-run-as-root --report-bindings -np 12 --hostfile ./ex_mpirun_hostfile.txt ./a.out

# with map-by
time mpirun --allow-run-as-root --report-bindings --map-by numa:PE=1 -np 12 --hostfile ./ex_mpirun_hostfile.txt ./a.out

tiem mpirun --allow-run-as-root --report-bindings --map-by hwthread:PE=1 -np 12 --hostfile ./ex_mpirun_hostfile.txt ./a.out

time mpirun --allow-run-as-root --report-bindings --map-by core:PE=1 -np 12 --hostfile ./ex_mpirun_hostfile.txt ./a.out
