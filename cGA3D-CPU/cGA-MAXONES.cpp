#include <cstdlib>
#include <iostream>
#include <string>
#include <cstdint>
#include <cstring>
#include <vector>
#include <cassert>
#include <cmath>
#include <chrono>

// Use (void) to silence unused warnings.
#define assertm(exp, msg) assert(((void)msg, exp))

const int C_SIZE  = 32;
// inds 64
//const int N_COLS  = 2;
//const int N_ROWS  = 2;
//const int N_DEPTH = 16;

// inds 128
const int N_COLS  = 4;
const int N_ROWS  = 4;
const int N_DEPTH = 4;

// inds 256
//const int N_COLS  = 8;
//const int N_ROWS  = 8;
//const int N_DEPTH = 1;

const int GENS  = 1000;

class Individual{
  private: 
    int chromosome[C_SIZE];
    int fitness=0;
    int x=0;
    int y=0;
    int z=0; 
  public:
    Individual(){
      initialize();
    }
  void initialize(){
      for(int i=0; i<C_SIZE; i++){
        double randVal = (float) rand()/RAND_MAX ;
        chromosome[i] = 0;
        if (randVal > 0.5)
          chromosome[i] = 1;
      }
     evaluate();
  }
  void setPosition(int x1,int y1, int z1){
      x=x1;
      y=y1;
      z=z1;
  }
  void dumpInfo(){
    std::cout << "Individual(" << x << ", " << y << ", " << z << ")" << std::endl;
    std::cout  << "Fitness -> " << fitness << std::endl;
    std::cout  << "Chromosome [ ";
    for(int i=0; i< C_SIZE;i++)
      std::cout << chromosome[i];
    std::cout << "]" << std::endl;

  }
  void setChromosome(int nC[]){
    for(int i=0; i<C_SIZE; i++){
      chromosome[i] = nC[i];
    }
  }

  int* getChromosome(){
    return chromosome;
  }

  void evaluate(){
    fitness = 0;
    for(int i=0; i<C_SIZE; i++){
      fitness += chromosome[i];
    }
  }
 
 void setFitness(int f){
   fitness = f;
 }
  
  int getFitness(){
    return fitness;
  }
};

Individual population[N_ROWS][N_COLS][N_DEPTH];
Individual temporal_population[N_ROWS][N_COLS][N_DEPTH];

int dk_mod(int a,int b) {
  int c = a % b;
  return (c < 0) ? c + b : c;
}

void cGA(){
  // initialize the population
  for(int i=0;i < N_ROWS;i++ ){
    for(int j=0; j < N_COLS; j++){
      for(int k=0; k < N_DEPTH; k++){
	Individual current = population[i][j][k];
	Individual selected = population[i][j][k];
	int s = (rand() % 5) + 1;
	assertm(s<=5, "SMTH WRONG");
	//s=10;
	// selection
	//std::cout << "i,j,k," << i << " " << j<< " " << k << std::endl;  
        if (s==0){
    		selected = population[ dk_mod((i-1), N_ROWS) ][j][k];
		//std::cout <<"0)" << ((i-1) % N_ROWS) << std::endl;
	}
	else if (s==1){
    		selected = population[ dk_mod((i+1), N_ROWS) ][j][k];
		//std::cout <<"1)" <<((i+1) % N_ROWS) << std::endl;
	}
  	else if (s==2){
    		selected = population[i][ dk_mod((j-1), N_COLS) ][k];
		//std::cout <<"2)" <<dk_mod((j-1), N_COLS) <<" NCOLS"<< N_COLS << std::endl;
		//assert(((j-1) % N_COLS) >= 0 );
	}
  	else if (s==3){
    		selected = population[i][dk_mod((j+1), N_COLS) ][k];
		//std::cout <<"3)" << ((j+1) % N_COLS)  << std::endl;
	}
  	else if (s==4){
    		selected = population[i][j][ dk_mod((k+1), N_DEPTH) ];
		//std::cout <<"4) " << ((k+1) % N_DEPTH)  << std::endl;
	}
  	else if (s==5){
    		selected = population[i][j][ dk_mod((k-1), N_DEPTH) ];
		//std::cout <<"5) "<< ((k-1) % N_DEPTH)  << std::endl;
	}
        // crossover
        int child_sequence1[C_SIZE];
        int child_sequence2[C_SIZE];
        int crosspoint = C_SIZE/2;
        
        int selectedBits[C_SIZE];
        int currentBits[C_SIZE];
        std::memcpy(selectedBits,selected.getChromosome(),C_SIZE*sizeof(int));
        std::memcpy(currentBits,current.getChromosome(),C_SIZE*sizeof(int));
        for (int p=0; p < C_SIZE; p++){
          if (p < crosspoint){
            //std::cout << selectedBits[p] << std::endl;
            child_sequence1[p] = selectedBits[p];
            child_sequence2[p] = currentBits[p];
          }
          else{
            child_sequence1[p] = currentBits[p];
            child_sequence2[p] = selectedBits[p];
          }
        }
        // perform the mutation

        for (int p=0; p<C_SIZE; p++){
          double randVal = (float) rand()/RAND_MAX ;
          if (randVal < 0.05) // 5% chance of a random mutation
            if (child_sequence1[p] == 1)
              child_sequence1[p] =0;
            else 
              child_sequence1[p] = 1;
        }
        // perform the mutation
        for (int p=0; p<C_SIZE; p++){
          double randVal = (float) rand()/RAND_MAX;
          if (randVal < 0.05) // 5% chance of a random mutation
            if (child_sequence2[p] == 1)
              child_sequence2[p] =0;
            else 
              child_sequence2[p] = 1;
        }
        Individual offspring1,offspring2;
	offspring1.setChromosome(child_sequence1);
	offspring1.setChromosome(child_sequence2);
        offspring1.evaluate();
        offspring2.evaluate();
      // check which is the best
      
      if (current.getFitness() >= offspring1.getFitness() && current.getFitness() >= offspring2.getFitness()){
        temporal_population[i][j][k].setChromosome(current.getChromosome());
      }
      else if(offspring1.getFitness() >= current.getFitness() && offspring1.getFitness()  >= offspring2.getFitness()){
        temporal_population[i][j][k].setChromosome(offspring1.getChromosome());
      }
      else
        temporal_population[i][j][k].setChromosome(offspring2.getChromosome());

        temporal_population[i][j][k].evaluate();

      }
   }
}
}



int main() {
  int generations = GENS;
  if(const char* env_p = std::getenv("GENS")){
    std::string s = env_p;
    generations = stoi(s);
  }
  std::cout << "Number of Generations: " << generations << '\n';

  std::cout << "Cellular Genetic Algorithm!"<<std::endl;
  for(int x = 0; x < 100; x++){
  // initialize the population
  for(int i=0;i < N_ROWS;i++ ){
    for(int j=0; j < N_COLS; j++){
      for(int k=0; k < N_DEPTH; k++){
        population[i][j][k].initialize();;
        population[i][j][k].setPosition(i,j,k);
      }
    }
  }

  std::chrono::steady_clock::time_point begin = std::chrono::steady_clock::now();
  for(int x=0; x < generations ; x++){
    cGA();
    // dumping results from temporal to current
    for(int i=0;i < N_ROWS;i++ ){
      for(int j=0; j < N_COLS; j++){
        for(int k=0; k < N_DEPTH; k++){
          population[i][j][k].setChromosome(temporal_population[i][j][k].getChromosome());
          population[i][j][k].setFitness(temporal_population[i][j][k].getFitness());
        }
      }
    }
  }
  std::chrono::steady_clock::time_point end = std::chrono::steady_clock::now();

  std::cout <<  std::chrono::duration_cast<std::chrono::milliseconds> (end - begin).count() << "[ms]" << std::endl;
}
//std::cout << "Time difference = " << std::chrono::duration_cast<std::chrono::microseconds>(end - begin).count() << "[µs]" << std::endl;
//std::cout << "Time difference = " << std::chrono::duration_cast<std::chrono::nanoseconds> (end - begin).count() << "[ns]" << std::endl;

  // printn result
  for(int i=0;i < N_ROWS;i++ ){
    for(int j=0; j < N_COLS; j++){
      for(int k=0; k < N_DEPTH; k++){
        temporal_population[i][j][k].dumpInfo();
      }
    }
  }
    return 0;
}

