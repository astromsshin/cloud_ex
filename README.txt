The cluster name is mycluster in these examples, and 
the number of hosts is 16 as described in 
ex_mpirun_hostfile.txt and ex_parallel_hostfile.txt.
The cluster consists of a single master and multiple slaves (i.e., minions).

See the following documents:

- Open MPI v4.0.x documents https://www.open-mpi.org/doc/v4.0/
  In particular, mpirun man page https://www.open-mpi.org/doc/v4.0/man1/mpirun.1.php 
  and FAQ: Running MPI jobs https://www.open-mpi.org/faq/?category=running

- GNU Parallel's documentation https://www.gnu.org/software/parallel/sphinx.html
  In particular, tutorial on remote execution https://www.gnu.org/software/parallel/parallel_tutorial.html#remote-execution

- Slurm sbatch document https://slurm.schedmd.com/sbatch.html
        FAQ document https://slurm.schedmd.com/faq.html
        OpenMPI FAQ document on Slurm https://www.open-mpi.org/faq/?category=slurm
