#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>
#include <math.h>

#define RANDSEED 901234
 
int main(int argc, char** argv) {

  long int i, niter = 50000000;
  int count = 0;
  int myrank, num_procs;
  double x,y, z, pi;
                               
  MPI_Init(&argc, &argv);

  MPI_Comm_rank(MPI_COMM_WORLD, &myrank);

  MPI_Comm_size(MPI_COMM_WORLD, &num_procs);

  srand(RANDSEED+myrank);

  int recieved_result[num_procs];

  /* Count how many samples are inside the unit circle. */
  for (i = 0; i < niter; ++i) {
    x= ((double)rand())/RAND_MAX;
    y =((double)rand())/RAND_MAX;
    z = sqrt(x*x+y*y);
    if (z <= 1.0) {
      count++;
    }
  }

  /* Collect the results on the MPI process 0 */
  if(myrank != 0) {
    MPI_Send(&count, 1, MPI_INT, 0, 1, MPI_COMM_WORLD);
  } else {
    for(i = 1; i < num_procs; ++i) {
      MPI_Recv(&recieved_result[i], num_procs, MPI_INT, MPI_ANY_SOURCE, 1, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
    }
  }
                                                               
  if (myrank == 0) {

    int final_count = 0;

    for(i = 1; i < num_procs; ++i) {
      final_count += recieved_result[i];
    }
    final_count += count;

    pi = ((double)final_count/(double)(niter * num_procs))*4.0;

    printf("Pi: %.12f\n", pi);
  }

  MPI_Finalize();                     //Close the MPI instance

  return 0;
}
