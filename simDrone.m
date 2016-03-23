% Copyright 2016 Elgiz Baskaya

% This file is part of curedRone.

% curedRone is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% curedRone is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with curedRone.  If not, see <http://www.gnu.org/licenses/>.

% DRONE DYNMAMICS SIMULATION

ti = 0.1;
sim_duration_min = 5;
tf = 60 * sim_duration_min;
t_s = 0 : ti : tf;

x_real = zeros(5,length(t_s));

% initial condition for the states
% xReal = [p q r Alpha Beta]';
x_real(:,1) = [0.1 0.1 0.1 9.23e-2 0.0124]';

control_torque =[0 0 0 0 0]';
% controlTorque = [contAileron1 contAileron2 contElevator1 contElevator2
% contRudder]'

flig_conditions = [40 500]';
% flightConditions = [vt altitude]'

for i=1:length(t_s)-1
  % Nonlinear attitude propagation
  % Integration via Runge - Kutta integration Algorithm
  x_real(:,i+1) = rungeKutta4('modelDrone', x_real(:,i), flig_conditions, control_torque, ti); 
end