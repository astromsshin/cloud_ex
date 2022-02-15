#!/bin/bash

# examples of running a single command in all hosts
parallel --nonall --sshloginfile ex_parallel_hostfile.txt hostname

parallel --onall --tag --sshloginfile ex_parallel_hostfile.txt 'echo $RANDOM+{} | bc' :::  3 4 5 6 7 8 9 10 11

parallel --nonall --workdir /mnt/mpi --sshloginfile ex_parallel_hostfile.txt 'hostname; touch $RANDOM-$(hostname).txt'

# examples of running a single command with arguments over the available hosts
parallel --workdir /mnt/mpi --sshloginfile ex_parallel_hostfile.txt 'hostname; touch $RANDOM-$(hostname)-{}.txt' :::  3 4 5 6 7 8 9

parallel --workdir /mnt/mpi --sshloginfile ex_parallel_hostfile.txt 'hostname; wc -l *-{}.txt' :::  3 4 5 6 7 8 9
