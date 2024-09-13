#include<stdio.h>
#include<stdlib.h>

__device__ int calc_square(int val)
{
	int val_square;
	val_square = val*val;
	return val_square;
}


__global__ void calc(int *aa, int *a, int problem_size)
{
	int i = blockIdx.x*blockDim.x+ threadIdx.x;
	if(i < problem_size)
	{
		aa[i] = calc_square(a[i]);
	}
}


int main()
{
	int size = 400 * sizeof(int);
	int a[400], aa[400], *ad, *aad;
	int i=0;
	

	//Initialize the vectors
	for(i=0; i<400; i++ )
	{
		a[i] = i;
	}

	// Add two vectors
	//for(i=0; i<400; i++ )
	//{
	//	aa[i] = calc_square(a[i]);		
	//}
	
	cudaMalloc(&ad,size);
	cudaMalloc(&aad,size);	
	
	int total_threads = 400;
	int num_threads_per_block = 256;
	int num_blocks = total_threads / num_threads_per_block + 1;
	
	cudaMemcpy(ad,a,size,cudaMemcpyHostToDevice);
	
	calc<<<num_blocks,num_threads_per_block>>>(aad,ad,400);
	
	cudaMemcpy(aa,aad,size,cudaMemcpyDeviceToHost);
	
	// print the output
	for(i=0; i<400; i++ )
	{
		printf("\t%d",aa[i]);
	}	
}




