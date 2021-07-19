# Hardware Architecture for a 3D Cellular Genetic Algorithm

In many application domains, optimization problems are approached under real-time constraints. Thus, both high algorithmic and processing performance is necessary. Cellular Genetic Algorithms (cGAs) have shown competitive performance when tackling difficult single objective combinatorial and continuous domain problems. Morover, it has been demonstrated that structural properties in cGAs, such as population topology dimension, local neighborhood configuration and ad-hoc selection mechanisms, allow not only further algorithmic improvement but also, these characteristics can be combined at hardware level for acceleration.

The presented hardware architecture explores the idea of multidimensional cellular genetic algorithms presented in:

[1] Alicia Morales-Reyes, Hugo Jair Escalante, Martin Letras, and Rene Cumplido. 2015. **An Empirical Analysis on Dimensionality in Cellular Genetic Algorithms**. *In Proceedings of the 2015 Annual Conference on Genetic and Evolutionary Computation (GECCO '15)*. Association for Computing Machinery, New York, NY, USA, 895–902. DOI:https://doi.org/10.1145/2739480.2754699

The proposed hardware architecture emulates a 3D population using a bidimensional set of specialized Processor Elements (PEs). Each PE evolves a sub-population by performing selection, crossover and mutation operators.

## Architecture Overview
