function generateCosine(InputLowerBound,OutputLowerBound,...
                        InputType,OutputType,AbsTol,RelTol)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
P = FunctionApproximation.Problem('cos');
P.Options.BreakpointSpecification = 'EvenSpacing';
P.InputTypes = InputType;
P.InputLowerBounds = InputLowerBound;
P.InputUpperBounds = OutputLowerBound;
P.OutputType = OutputType;
P.Options.AbsTol = AbsTol;
P.Options.RelTol = RelTol;

S=solve(P);
err = compare(S);
approximate(S);
end

