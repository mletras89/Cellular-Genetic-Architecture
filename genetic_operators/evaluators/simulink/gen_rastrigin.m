% generatin rastrigin
problem = FunctionApproximation.Problem(@(x,y) 20+x^2+y^2-10*(cos(2*pi*x))+cos(2*pi*y));
problem.InputTypes =[numerictype(1,16,13) numerictype(1,16,13)];
problem.OutputType =numerictype(1,16,7);
problem.InputLowerBounds = [-5 -5];
problem.InputUpperBounds = [5 5];

problem.Options.AbsTol = 2^-4;
problem.Options.RelTol = 2^-2;

S=solve(problem);
err = compare(S);
approximate(S)
