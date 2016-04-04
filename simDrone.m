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
sim_duration_min = 10;
tf = 60 * sim_duration_min;
t_s = 0 : ti : tf;

x_real = zeros(14,length(t_s));

% initial condition for the states
% xReal = [q0 q1 q2 q3 p q r x_n y_e z_d u_b v_b w_b eng_speed]';
% 10 - 5 - 10 angle input as quaternions : 0.9918 0.0829 0.0509 0.0829
x_real(:,1) = [1 0 0 0 0 0 0 0 0 0 1e-5 1e-5 1e-5 1e-2]';

control_torque = [0 0 0.0 0.0 0]';
% controlTorque = [contAileron1 contAileron2 contElevator1 contElevator2
% contRudder]'

flig_conditions = [0 0 0]' ;
% flightConditions = [wind_n wind_e wind_d]'

for i=1:length(t_s)-1
  % Nonlinear attitude propagation
  % Integration via Runge - Kutta integration Algorithm
  x_real(:,i+1) = rungeKutta4('modelDrone', x_real(:,i), flig_conditions, control_torque, ti); 
end

% for animation
transPosition.signals.values = [x_real(8,:); x_real(9,:); x_real(10,:)]';
transPosition.time = t_s;
transPosition.signals.dimensions = 3;

[pisi teta fi] = quat2angle([x_real(1,:)' x_real(2,:)' x_real(3,:)' x_real(4,:)']);
eulerAngles.signals.values = [pisi teta fi];
eulerAngles.time = t_s;
eulerangles.signals.dimensions = 3;
fi = rad2deg(fi);
pisi = rad2deg(pisi);
teta = rad2deg(teta);
