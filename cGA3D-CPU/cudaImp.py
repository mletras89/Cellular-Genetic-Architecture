#-------- Implementation of basic GPU-parallel Genetic Algorithm for with python CUDA using Numba  ---------#

import numpy as np
from numba import cuda
import time
import random
import math

#-------- Verify CUDA access  ---------#
print(cuda.gpus)


#-------- Parallel kernel function using CUDA  ---------#
@cuda.jit
def eval_genomes_kernel(chromosomes, fitnesses, pop_length, chrom_length):
  # Thread id in a 1D block
  tx = cuda.threadIdx.x
  # Block id in a 1D grid
  ty = cuda.blockIdx.x
  # Block width, i.e. number of threads per block
  bw = cuda.blockDim.x
  # Compute flattened index inside the array
  pos = tx + ty * bw
  if pos < pop_length:  # Check array boundaries
  # in this example the fitness of an individual is computed by an arbitary set of algebraic operations on the chromosome
    num_loops = 3000
    for i in range(num_loops):
      fitnesses[pos] += chromosomes[pos*chrom_length + 1] # do the fitness evaluation
    for i in range(num_loops):
      fitnesses[pos] -= chromosomes[pos*chrom_length + 2]
    for i in range(num_loops):
      fitnesses[pos] += chromosomes[pos*chrom_length + 3]

    if (fitnesses[pos] < 0):
      fitnesses[pos] = 0


def eval_Max_Ones(chromosome,chromLength):
  count = 0
  for l in range(chromLength):
    if chromosome[l] == 1 :
      count = count+1
  return count
  
def geneticOperators(neighbours,current,currentV,chromSize):
  # now we perform selection
  selected = neighbours[random.randint(0,5)]
  # crossover        
  crosspoint = math.floor(chromSize/2)
  
  child_sequence1 = np.concatenate((selected[:crosspoint],current[crosspoint:] ),axis=None)
  child_sequence2 = np.concatenate((current[:crosspoint],selected[crosspoint:] ),axis=None)
  #print("child1 "+str(child_sequence1.size))
  #print("child2 "+str(child_sequence2.size))
  child_genome1 = np.zeros(chromSize, dtype=np.uint8)
  child_genome2 = np.zeros(chromSize, dtype=np.uint8)
  
  #mutate genome
  for a in range(chromSize):
    if random.uniform(0,1) < 0.05: # 5% chance of a random mutation
      val = random.uniform(0,1)
      child_genome1[a] = not child_sequence1[a]
    else:
      child_genome1[a] = child_sequence1[a]
  
  #mutate genome
  for a in range(chromSize):
    if random.uniform(0,1) < 0.05: # 5% chance of a random mutation
      val = random.uniform(0,1)
      child_genome2[a] = not child_sequence2[a]
    else:
      child_genome2[a] = child_sequence2[a]
  
  # evaluate new inds
  fV1 = eval_Max_Ones(child_genome1,chromSize)
  fV2 = eval_Max_Ones(child_genome2,chromSize)
  if currentV >= fV1 and currentV >= 2:
    return [current,currentV]
  elif fV1 >= fV2 and fV1 >= currentV:
    return [child_genome1,fV1]
  elif fV2 >= fV1 and fV2 >= currentV:
    return [child_genome2,fV2]

@cuda.jit
def kernel_generation(chromosomes, fitnesses,rows,cols,depth,chromSize):
  i = cuda.threadIdx.x
  j = cuda.threadIdx.y
  k = cuda.threadIdx.z

  neighbours = np.zeros(shape=(6,chromSize),dtype = np.int8)
  neighbours[0] =  chromosomes[(i-1)%rows][j][k]     #  north 
  neighbours[1] = chromosomes[(i+1) % rows][j][k]   # south
  neighbours[2] = chromosomes[i][(j-1) % rows][k]   # west
  neighbours[3] = chromosomes[i][(j+1) % rows][k]   # east
  neighbours[4] = chromosomes[i][j][(k+1) % depth]  #  back
  neighbours[5] = chromosomes[i][j][(k-1) % depth]  #  front
  current = chromosomes[i][j][k]
  currentV = fitnesses[i][j][k]

  cuda.syncthreads()

  [newC,newV] = geneticOperators(neighbours,current,currentV,chromSize)
  chromosomes[i][j][k] = newC
  fitnesses[i][j][k] = newV


##-------- Function to compute next generation in Genetic Algorithm  ---------#
##-------- Performs Selection, Crossover, and Mutation operations  ---------#
def next_generation(chromosomes, fitnesses,rows,cols,depth,chromSize):
  new_chromosomes = np.zeros(shape=(n_cols,n_rows,n_depth,chrom_size), dtype = np.int8) 
  new_fitnesses = np.zeros(shape=(n_cols,n_rows,n_depth),dtype=np.int8)

  for i in range(rows):
    for j in range(cols):
      for k in range(depth):
#                   (i-1,j)
#                   (north) 
# (i,j-1) <- (west) (i,j) (east) -> (i,j+1)
#                   (south)
#                  (i+1,j)
        neighbours = np.zeros(shape=(6,chromSize),dtype = np.int8)
        neighbours[0] =  chromosomes[(i-1)%rows][j][k]     #  north 
        neighbours[1] = chromosomes[(i+1) % rows][j][k]   # south
        neighbours[2] = chromosomes[i][(j-1) % rows][k]   # west
        neighbours[3] = chromosomes[i][(j+1) % rows][k]   # east
        neighbours[4] = chromosomes[i][j][(k+1) % depth]  #  back
        neighbours[5] = chromosomes[i][j][(k-1) % depth]  #  front
        current = chromosomes[i][j][k]
        currentV = fitnesses[i][j][k]
        [newC,newV] = geneticOperators(neighbours,current,currentV,chromSize)
        new_chromosomes[i][j][k] = newC
        new_fitnesses[i][j][k] = newV

  # update population
  for i in range(rows):
    for j in range(cols):
      for k in range(depth):
        chromosomes[i][j][k] = new_chromosomes[i][j][k]
        fitnesses[i][j][k] = new_fitnesses[i][j][k]
     
  
#-------- Initialize Population  ---------#
random.seed(1111)
pop_size = 5000
n_cols  = 2
n_rows  = 2
n_depth = 2
chrom_size = 64
num_generations = 5000
#fitnesses = np.zeros(pop_size, dtype=np.float32)
fitnesses = np.zeros(shape=(n_cols,n_rows,n_depth),dtype=np.int8)
chromosomes = np.zeros(shape=(n_cols,n_rows,n_depth,chrom_size), dtype = np.int8)

for i in range(n_cols):
  for j in range(n_rows):
    for k in range(n_depth):
      for l in range(chrom_size):
        val =  random.uniform(0,1)
        if val > 0.5 :
          chromosomes[i][j][k][l] = 1
        else:
          chromosomes[i][j][k][l] = 0

print(chromosomes)
print(fitnesses)

for i in range(n_rows):
  for j in range(n_cols):
    for k in range(n_depth):
      fitnesses[i][j][k] = eval_Max_Ones(chromosomes[i][j][k],chrom_size)

print(fitnesses)

##-------- Measure time to perform some generations of the Genetic Algorithm without CUDA  ---------#
#
print("NO CUDA:")
start = time.time()
### Genetic Algorithm on CPU
for i in range(num_generations):
  print("Gen " + str(i) + "/" + str(num_generations))
#  eval_genomes_plain(chromosomes, fitnesses)
  next_generation(chromosomes, fitnesses,n_rows,n_cols,n_depth,chrom_size) #Performs selection, mutation, and crossover operations to create new generation

#  fitnesses = np.zeros(pop_size, dtype=np.float32) #Wipe fitnesses
#  
end = time.time()
print("time elapsed: " + str((end-start)))
print(chromosomes)
print(fitnesses)
#print("First chromosome: " + str(chromosomes[0])) #To show computations were the same between both tests
#
#
##-------- Prepare kernel ---------#
## Set block & thread size
#threads_per_block = 256
#blocks_per_grid = (chromosomes.size + (threads_per_block - 1))
#
##--------- Initialize population again for a new run -------------- #
#random.seed(1111)
#fitnesses = np.zeros(pop_size, dtype=np.float32)
#chromosomes = np.zeros(shape=(pop_size, chrom_size), dtype = np.float32)
#for i in range(pop_size):
#  for j in range(chrom_size):
#    chromosomes[i][j] = random.uniform(0,1) #random float between 0.0 and 1.0
#
##-------- Measure time to perform some generations of the Genetic Algorithm with CUDA  ---------#
#print("CUDA:")
#start = time.time()
## Genetic Algorithm on GPU
#for i in range(num_generations):
#  print("Gen " + str(i) + "/" + str(num_generations))
#  chromosomes_flat = chromosomes.flatten()
#  
#  eval_genomes_kernel[blocks_per_grid, threads_per_block](chromosomes_flat, fitnesses, pop_size, chrom_size)
#  next_generation(chromosomes, fitnesses) #Performs selection, mutation, and crossover operations to create new generation
#  fitnesses = np.zeros(pop_size, dtype=np.float32) # Wipe fitnesses
#
#  
#end = time.time()
#print("time elapsed: " + str((end-start)))
#print("First chromosome: " + str(chromosomes[0])) #To show computations were the same between both tests
