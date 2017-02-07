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
% Attitude kinematic and dynamic equations of motion
% Translational Motion of a drone

%% Explanation of states and control inputs

% q .:. quaternion
% q = q0 + q1 * i + q2 * j + q3 * k

% w .:. angular velocity vector with components p, q, r [rad/s]
% w = [p q r]'
% w describes the angular motion of the body frame b with respect to
% navigation frame North East Down(NED), expressed in body frame.

% x .:. position of the drone in NED reference frame [m]
% x = [x_n y_e z_d]'

% v .:. inertial velocity vector of the drone center of mass [m/s]
% v = [u_b v_b w_b]'

% x_real .:. state vector [num_of_states x length(t_s)]
% x_real = [q0 q1 q2 q3 p q r x_n y_e z_d u_b v_b w_b]'

% control_deflections .:. control surface deflections [unitless] and have
% have values in interval[-1,1]
% control_deflections = [contAileron1 contAileron2 contElevator1 contElevator2
% contRudder]'  ! deflections are mapped into interval [-1,1]

% wind_ned .:. wind disturbance in NED frame 
% wind_ned = [wind_n wind_e wind_d]'

%% Simulation parameters - select the integration step size ti and 
% simulation duration in minutes sim_duration_min 

% simulation time interval
ti = 0.02;
% simulation duration in minutes
sim_duration_min = 3;

tf = 60 * sim_duration_min;
t_s = 0 : ti : tf;

% initialization with zeros for code efficiency
x_real = zeros(14,length(t_s));

%% Inputs necessary for simulation
% initial condition for the states
% x_real = [q0 q1 q2 q3 p q r x_n y_e z_d u_b v_b w_b eng_speed]';
x_real(:,1) = [1 0 0 0 0 0 0 0 0 0 1e-5 1e-5 1e-5 1e-2]';

% control_deflections = [contAileron1 contAileron2 contElevator1 contElevator2
% contRudder]'
control_deflections = [0 0 0 0 0]';

% wind_ned .:. [wind_n wind_e wind_d]'
wind_ned = [0 0 0]';

% stability derivatives and some other drone specific 
% parameters (such as inertia) are included
configDrone;

%% Numeric integration of attitude and translational motion of drone
for i=1:length(t_s)-1
  % Nonlinear attitude propagation
  % Integration via Runge - Kutta integration Algorithm
  x_real(:,i+1) = rungeKutta4('modelDrone', x_real(:,i), control_deflections, wind_ned, ti); 
end