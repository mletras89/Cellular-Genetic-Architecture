[x1,x2]=meshgrid(-5.12:0.1:5.12,-5.12:0.1:5.12);
rast =20+x1.^2+x2.^2-10*(cos(2*pi*x1)+cos(2*pi*x2));
surf(x1,x2,rast,'linestyle','none');

max_x1 = max(x1(:));
min_x1 = min(x1(:));
max_x2 = max(x2(:));
min_x2 = min(x2(:));
max_rast = max(rast(:));
min_rast = min(rast(:));

fprintf("Rastrigin function...\n");
fprintf("The maximum value of x1 is %f\n",max_x1);
fprintf("The minimum value of x1 is %f\n",min_x1);
fprintf("The maximum value of x2 is %f\n",max_x2);
fprintf("The minimum value of x2 is %f\n",min_x2);
fprintf("The maximum value of rastrigin is %f\n",max_rast);
fprintf("The minumum value of rastrigin is %f\n",min_rast);
hold on;

cos_inputs = 2*pi*x1;
cos_values = cos(cos_inputs);
max_cos_inputs = max(cos_inputs(:));
min_cos_inputs = min(cos_inputs(:));
max_cos_values = max(cos_values(:));
min_cos_values = min(cos_values(:));
fprintf("The minimum value of cos_inputs is %f\n",min_cos_inputs);
fprintf("The maximum value of cos_inptus is %f\n",max_cos_inputs);

fprintf("The minimum value of cos_values is %f\n",min_cos_values);
fprintf("The maximum value of cos_values is %f\n",max_cos_values);


figure;
% maximum value input cosine 6*10+5=65
% minimun value input cosine 6*-10+5=-60

[x1,x2]=meshgrid(-10:0.1:10,-10:0.1:10);
shubert = (cos(2*x1+1) + 2*cos(3*x1+2) + 3*cos(4*x1+3) + 4*cos(5*x1+4) + 5*cos(6*x1+5)) .* (cos(2*x2+1) + 2*cos(3*x2+2) + 3*cos(4*x2+3) + 4*cos(5*x2+4) + 5*cos(6*x2+5));
surf(x1,x2,shubert,'linestyle','none');
hold on;

max_x1 = max(x1(:));
min_x1 = min(x1(:));
max_x2 = max(x2(:));
min_x2 = min(x2(:));
max_shubert = max(shubert(:));
min_shubert = min(shubert(:));

fprintf("Shubert function...\n");
fprintf("The maximum value of x1 is %f\n",max_x1);
fprintf("The minimum value of x1 is %f\n",min_x1);
fprintf("The maximum value of x2 is %f\n",max_x2);
fprintf("The minimum value of x2 is %f\n",min_x2);
fprintf("The maximum value of shubert is %f\n",max_shubert);
fprintf("The minumum value of shubert is %f\n",min_shubert);


figure;
[x1,x2]=meshgrid(-10:0.1:10,-10:0.1:10);
griewank = (x1.^2+ x2.^2)./4000 - cos(x1/sqrt(1)).*cos(x2/sqrt(2)) + 1;
surf(x1,x2,griewank,'linestyle','none');
hold on;

max_x1 = max(x1(:));
min_x1 = min(x1(:));
max_x2 = max(x2(:));
min_x2 = min(x2(:));
max_griewank = max(griewank(:));
min_griewank = min(griewank(:));

fprintf("Shubert function...\n");
fprintf("The maximum value of x1 is %f\n",max_x1);
fprintf("The minimum value of x1 is %f\n",min_x1);
fprintf("The maximum value of x2 is %f\n",max_x2);
fprintf("The minimum value of x2 is %f\n",min_x2);
fprintf("The maximum value of griewank is %f\n",max_griewank);
fprintf("The minumum value of griewank is %f\n",min_griewank);

cos_inputs_one = x2/sqrt(1);
cos_inputs_one_min = min(cos_inputs_one(:));
cos_inputs_one_max = max(cos_inputs_one(:));
cos_inputs_two = x2/sqrt(2);
cos_inputs_two_min = min(cos_inputs_two(:));
cos_inputs_two_max = max(cos_inputs_two(:));

fprintf("The minimum value of cos_inputs_one is %f\n",cos_inputs_one_min);
fprintf("The maximum value of cos_inptus_one is %f\n",cos_inputs_one_max);

fprintf("The minimum value of cos_values_two is %f\n",cos_inputs_two_min);
fprintf("The maximum value of cos_values_two is %f\n",cos_inputs_two_max);

% generate cos
P = FunctionApproximation.Problem('cos');
P.Options.BreakpointSpecification = 'EvenSpacing';
P.InputTypes = numerictype(1,32,25);
P.InputLowerBounds = -33;
P.InputUpperBounds = 33;

P.Options.AbsTol = 2^-10;
P.Options.RelTol = 2^-6;