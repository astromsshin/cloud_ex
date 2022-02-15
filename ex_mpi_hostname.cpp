#include <mpi.h>
#include <unistd.h>
#include <iostream>

int main(int argc, char** argv) {

  int myrank;
  int num_procs;
  int dummy_int;
  char processor_name[256];

  MPI_Init(&argc, &argv);

  MPI_Comm_rank(MPI_COMM_WORLD, &myrank);

  MPI_Comm_size(MPI_COMM_WORLD, &num_procs);

  MPI_Get_processor_name(processor_name, &dummy_int);

  sleep(30);

  std::cout << "Hello from process " << myrank << " of " << num_procs << 
  " at " << processor_name << " after sleeping 30 seconds" << std::endl;

  MPI_Finalize();

  return 0;

}
