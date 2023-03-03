#include <stdio.h>

#include <cstdlib>
#include <iostream>
#include <string>
#include <cstdint>
#include <cstring>
#include <vector>
#include <cassert>
#include <cmath>
#include <chrono>
#include <cuda.h>
#include <curand.h>
#include <curand_kernel.h>

// Use (void) to silence unused warnings.
#define assertm(exp, msg) assert(((void)msg, exp))
const int C_SIZE  = 32;

// inds 64
int N_COLS  = 2;
int N_ROWS  = 2;
int N_DEPTH = 2;

//const int N_COLS  = 4;
//const int N_ROWS  = 4;
//const int N_DEPTH = 4;

//const int N_COLS  = 8;
//const int N_ROWS  = 8;
//const int N_DEPTH = 1;

int GENS  = 20000;


  void initializePopulation(int* chromosome, int offset){
      for(int i=0; i<C_SIZE; i++){
        double randVal = (float) rand()/RAND_MAX ;
        chromosome[offset+i] = 0;
        if (randVal > 0.5)
          chromosome[offset+i] = 1;
      }
  }

  __device__ int evaluate(int* chromosome,int offset){
// ------------------------------
// X    00    01    10    11
//-------------------------------
//Iso1  m     0     0     m-a
//Iso2  0     0     0     m
//-------------------------------
    int fitness = 0;
    if (chromosome[offset] == 1 && chromosome[offset+1] == 1)
      fitness += 2;
    for(int i=2; i< 16 ;i++){
      if(chromosome[offset+2*i-1]==0 && chromosome[offset+2*i-2]==0)
        fitness+= 2;
      else if(chromosome[offset+2*i-1]==1 && chromosome[offset+2*i-2]==1)
        fitness += 1;
    }
    return fitness;
  }

__device__ int generateSelection(curandState* globalState, int ind)
{
    curandState localState = globalState[ind];
    int RANDOM = floor(10*curand_uniform( &localState));
    globalState[ind] = localState;
    return RANDOM;
}

__device__ float generateMutation(curandState* globalState, int ind)
{
    curandState localState = globalState[ind];
    float RANDOM = curand_uniform( &localState );
    globalState[ind] = localState;
    return RANDOM;
}

__global__ void setup_kernel ( curandState * state, unsigned long seed,int N_ROWS, int N_COLS )
{
  int i = threadIdx.x; 
  int j = threadIdx.y; 
  int k = threadIdx.z;
  int offset =  i*N_ROWS*N_COLS + j*N_COLS + k;
  curand_init( seed, offset , 0, &state[offset]  );
}

int dk_mod(int a,int b) {
  int c = a % b;
  return (c < 0) ? c + b : c;
}


__device__ int kernel_dk_mod(int a,int b) {
  int c = a % b;
  return (c < 0) ? c + b : c;
}


__global__ void KernelTest(float *pop,float *temp_pop, curandState* globalState,int N_ROWS, int N_COLS) {
  int i = threadIdx.x; 
  int j = threadIdx.y; 
  int k = threadIdx.z;
  int offset = i*N_ROWS*N_COLS + j*N_COLS + k;
  float val = generateSelection(globalState,offset);
  *(temp_pop+offset) = val;
  //temp_pop[offset] = 5;
  printf("Hello, world from the device from thread (%d,%d,%d) offset=%d value=%f!\n",i,j,k,offset,val); 

}

__global__ void KernelCGA(int* pop, int* fitness, int* temp_pop, int* temp_fitness, curandState* globalState,int N_ROWS, int N_COLS) {
  int i = threadIdx.x; 
  int j = threadIdx.y; 
  int k = threadIdx.z;
  
  int offset_chromosome = (i*N_ROWS*N_COLS + j*N_COLS + k)*C_SIZE;
  int offset_fitness    = i*N_ROWS*N_COLS + j*N_COLS + k;
  int offset_rng    = i*N_ROWS*N_COLS + j*N_COLS + k;

  int s = generateSelection(globalState, offset_rng);
  int selectedOffset_fitness    = offset_fitness; // offset selected
  int selectedOffset_chromosome = offset_chromosome; // offset selected

  if (s==0){
    selectedOffset_fitness = kernel_dk_mod((i-1),N_ROWS)*N_ROWS *N_COLS + j*N_COLS + k;
  }
  else if (s==1){
    selectedOffset_fitness = kernel_dk_mod((i+1),N_ROWS)*N_ROWS *N_COLS + j*N_COLS + k;
  }
  else if (s==2){
    selectedOffset_fitness = i*N_ROWS*N_COLS+ kernel_dk_mod((j-1),N_COLS)*N_COLS+k;
  }
  else if (s==3){
    selectedOffset_fitness = i*N_ROWS*N_COLS+ kernel_dk_mod((j+1),N_COLS)*N_COLS+k;
  }
  else if (s==4){
    selectedOffset_fitness = i*N_ROWS*N_COLS+ j*N_COLS+ kernel_dk_mod((k+1),N_COLS) ;
  }
  else if (s>5){
    selectedOffset_fitness = i*N_ROWS*N_COLS+ j*N_COLS+ kernel_dk_mod((k-1),N_COLS) ;
  }
  selectedOffset_chromosome = selectedOffset_fitness * C_SIZE;

  int child_sequence1[C_SIZE];
  int child_sequence2[C_SIZE];
  int crosspoint = C_SIZE/2;
  // Performing the crossver operation
  for (int p=0; p < C_SIZE; p++){
    if (p < crosspoint){
      child_sequence1[p] = pop[selectedOffset_chromosome+p];
      child_sequence2[p] = pop[offset_chromosome+p];
    }
    else{
      child_sequence1[p] = pop[offset_chromosome+p];
      child_sequence2[p] = pop[selectedOffset_chromosome+p];
    }                                            
  }
  // perform the mutation
  for (int p=0; p<C_SIZE; p++){
    double randVal = generateMutation(globalState,offset_rng);
    if (randVal < 0.05)    // 5% chance of a random mutation
      if (child_sequence1[p] == 1)
        child_sequence1[p] =0;
      else 
        child_sequence1[p] = 1;
  }
  // perform the mutation
  for (int p=0; p<C_SIZE; p++){
    double randVal = generateMutation(globalState,offset_rng);
    if (randVal < 0.05) // 5% chance of a random mutation
      if (child_sequence2[p] == 1)
        child_sequence2[p] =0;
      else 
        child_sequence2[p] = 1;
  }
  int fitness_current = evaluate(pop,offset_chromosome);
  int fitness_i1      = evaluate(child_sequence1,0);
  int fitness_i2      = evaluate(child_sequence2,0);
  // decide the best individual
  if (fitness_current >= fitness_i1 && fitness_current  >= fitness_i2){
    // copy current in temp
    for (int c=0; c<C_SIZE; c++){ 
      temp_pop[offset_chromosome+c] = pop[offset_chromosome+c];
    }	  
    temp_fitness[offset_fitness]  = fitness[offset_fitness];
  }
  else if(fitness_i1 >= fitness_current && fitness_i1 >= fitness_i2){
    // copy current in ind1
    for (int c=0; c<C_SIZE; c++){ 
      temp_pop[offset_chromosome+c] = child_sequence1[c];
    }	  
    temp_fitness[offset_fitness]  = fitness_i1;
  }
  else{
    // copy current in ind1
    for (int c=0; c<C_SIZE; c++){ 
      temp_pop[offset_chromosome+c] = child_sequence1[c];
    }	  
    temp_fitness[offset_fitness]  = fitness_i1;
  }
//  for(int c=0 ; c<2; c++){
//    temp_pop[offset_chromosome+c] = 1;
//  }
//  temp_fitness[offset_fitness] = evaluate(temp_pop,offset_chromosome);
//
//  printf("Device from thread (%d,%d,%d) offsetPop=%d offsetF=%d!\n",i,j,k,offset_chromosome,offset_fitness); 
}

void cGACuda(){
  curandState* devStates;
  cudaMalloc (&devStates, N_ROWS * N_COLS * N_DEPTH * sizeof(curandState));
  srand(time(0));
  /** ADD THESE TWO LINES **/
  int seed = rand();
  int numBlocks = 1;
  dim3 threadsPerBlock(N_ROWS, N_COLS, N_DEPTH);
  setup_kernel<<<numBlocks,threadsPerBlock>>>(devStates,seed, N_ROWS, N_COLS);

  int *pop = (int*)malloc(N_ROWS * N_COLS * N_DEPTH * C_SIZE* sizeof(int));       // array on the host machine
  int *fitness = (int*)malloc(N_ROWS * N_COLS * N_DEPTH * sizeof(int));          // array on the host machine
  int *pop_gpu,*tem_pop_gpu;   // arrays in the gpu memory
  int *fitness_gpu,*tem_fitness_gpu;   // arrays in the gpu memory


  if (pop == NULL)
  {
      fprintf(stderr, "Out of memory");
      exit(0);
  }
// init pop
  std::cout << "Init Memory " << std::endl;
  for(int i=0;i < N_ROWS;i++ ){       
    for(int j=0; j < N_COLS; j++){
      for(int k=0; k < N_DEPTH; k++){
        for(int c=0; c< C_SIZE; c++){
	  initializePopulation(pop,(i*N_ROWS*N_COLS + j*N_COLS + k) * C_SIZE);;
	}
	fitness[ i*N_ROWS*N_COLS + j*N_COLS + k] = 5;
      }
    }
  }
  // 2.c. allocate the memory on the GPU
  cudaMalloc( (void**)&pop_gpu, N_ROWS * N_COLS * N_DEPTH* C_SIZE * sizeof(int));
  cudaMalloc( (void**)&tem_pop_gpu, N_ROWS * N_COLS * N_DEPTH * C_SIZE* sizeof(int));
  cudaMalloc( (void**)&fitness_gpu, N_ROWS * N_COLS * N_DEPTH * sizeof(int));
  cudaMalloc( (void**)&tem_fitness_gpu, N_ROWS * N_COLS * N_DEPTH * sizeof(int));

  for(int x=0;x<GENS;x++){
    std::cout << "It:" << x << std::endl;
    // 2.d. copy the arrays 'a' and 'b' to the GPU
   cudaMemcpy(pop_gpu     , pop     , N_ROWS * N_COLS * N_DEPTH * C_SIZE* sizeof(int) , cudaMemcpyHostToDevice );
   cudaMemcpy(fitness_gpu , fitness , N_ROWS * N_COLS * N_DEPTH * sizeof(int) , cudaMemcpyHostToDevice );

  // here calls the kernel
  KernelCGA<<<numBlocks,threadsPerBlock >>>(pop_gpu,fitness_gpu,tem_pop_gpu,tem_fitness_gpu,devStates, N_ROWS, N_COLS);
  cudaDeviceSynchronize();
  std::cout << "Error: " << cudaGetErrorString(cudaGetLastError()) << '\n';
  //KernelCGA(int pop[][][], int fitness[][][], int temp_pop[][][], int temp_fitness, curandState* globalState)

  // here read back the result from the kernel
  cudaMemcpy( pop, tem_pop_gpu, N_ROWS * N_COLS * N_DEPTH * C_SIZE*sizeof(int)  , cudaMemcpyDeviceToHost );
  cudaMemcpy( fitness, tem_fitness_gpu, N_ROWS * N_COLS * N_DEPTH * sizeof(int)  , cudaMemcpyDeviceToHost );
  }
  std::cout << "Dumping result " << std::endl;
  for(int i=0;i < N_ROWS;i++ ){       
    for(int j=0; j < N_COLS; j++){
      for(int k=0; k < N_DEPTH; k++){
	std::cout << "C: ";
	for(int c=0; c < C_SIZE; c++){ 
	  std::cout << pop[(i*N_ROWS*N_COLS + j*N_COLS + k) * C_SIZE+ c] << ",";
	}
	std::cout <<std::endl << "F:" << fitness[i*N_ROWS*N_COLS + j*N_COLS + k] << std::endl;
      }
    }
  }
  free(pop);
  free(fitness); 
  // free the memory we allocated on the GPU
  cudaFree( pop_gpu );
  cudaFree( tem_pop_gpu );
  cudaFree( fitness_gpu );
  cudaFree( tem_fitness_gpu );
}

int main() {
  if(const char* env_p = std::getenv("GENS")){
        std::string s = env_p;
        GENS = stoi(s);
  }
  if(const char* env_p = std::getenv("COLS")){
        std::string s = env_p;
        N_COLS = stoi(s);
  } 
  if(const char* env_p = std::getenv("ROWS")){
        std::string s = env_p;
        N_ROWS = stoi(s);
  } 
  if(const char* env_p = std::getenv("DEPTH")){
        std::string s = env_p;
        N_DEPTH = stoi(s);
  } 
  cGACuda();

  return 0;
}


