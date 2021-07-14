% generatin rastrigin
problem = FunctionApproximation.Problem(@(x,y) (cos(2*x+1) + 2*cos(3*x+2) + 3*cos(4*x+3) + 4*cos(5*x+4) + 5*cos(6*x+5)) * (cos(2*y+1) + 2*cos(3*y+2) + 3*cos(4*y+3) + 4*cos(5*y+4) + 5*cos(6*y+5)));

problem.InputTypes =[numerictype(1,16,13) numerictype(1,16,13)];
problem.OutputType =numerictype(1,16,7);
problem.InputLowerBounds = [-5 -5];
problem.InputUpperBounds = [5 5];

problem.Options.AbsTol = 2^-4;
problem.Options.RelTol = 2^-2;

S=solve(problem);
err = compare(S);
%approximate(S)
