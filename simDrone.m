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

% DRONE DYNAMICS SIMULATION

clear all;
clc;
configDrone;

ti = 0.01;
sim_duration_min = 2;
tf = 60 * sim_duration_min;
t_s = 0 : ti : tf;

x_real = zeros(13,length(t_s));

% initial condition for the states
% xReal = [q0 q1 q2 q3 p q r x_n y_e z_d u_b v_b w_b]';
x_real(:,1) = [1 0 0 0 0 0 0 0 0 500 13 1e-5 1.7]';

control_input = [0 0 110]';
% control_input = [contAileron contElevator contEngine]'

wind_ned = [0 0 0]';
% wind_ned .:. [wind_n wind_e wind_d]'

for i=1:length(t_s)-1
  % Nonlinear attitude propagation
  % Integration via Runge - Kutta integration Algorithm
  x_real(:,i+1) = rungeKutta4('modelDrone', x_real(:,i), control_input, wind_ned, ti); 
end