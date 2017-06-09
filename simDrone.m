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

% x_real .:. state vector [num_of_states x length(t_s)]
% x_real = [q0 q1 q2 q3 p q r x_n y_e z_d u_b v_b w_b]'
%       q .:. quaternion
%       q = q0 + q1 * i + q2 * j + q3 * k
%       w .:. angular velocity vector with components p, q, r [rad/s]
%       w = [p q r]'
%       w describes the angular motion of the body frame b with respect to
%       navigation frame North East Down(NED), expressed in body frame.
%       x .:. position of the drone in NED reference frame [m]
%       x = [x_n y_e z_d]'
%       v .:. inertial velocity vector of the drone center of mass [m/s]
%       v = [u_b v_b w_b]'


% control_input .:. controller inputs
% control_input = [deflect_ail[degrees] deflect_elev[degrees] 
%                  engine_speed[rev/s]]'

% wind_ned .:. wind disturbance in NED frame 
% wind_ned = [wind_n wind_e wind_d]'

% outputs : sensor_out_sim  .:. simulated sensor measurements - 
%                               acc_out_sim [m/s/s] 
%                               gyro_out_sim [deg/s]
%                               sensor_out_sim = [acc_out_sim; gyro_out_sim]

%% Simulation parameters - select the integration step size ti and 
% simulation duration in minutes sim_duration_min 

% simulation time interval
ti = 0.02;
% simulation duration in minutes
sim_duration_min = 3;
% start time of fault in minutes
t_fault_init_min = 3;

tf = 60 * sim_duration_min;
t_s = 0 : ti : tf;

% start time of fault in seconds
t_fault = 60 * (t_fault_init_min - 1);
% index of faulty situations during flight
t_f = (t_fault / ti + 1) + 1 : length(t_s);

%% initialization with zeros for code efficiency
x_real = zeros(13,length(t_s));
sensor_sim_out = zeros(6,length(t_s));

%% Inputs necessary for simulation
% initial condition of the state vector
x_real(:,1) = [1 0 0 0 0 0 0 0 0 500 8 1e-5 1.7]';

% controller inputs
control_desired =  [4 0 110]' .* ones(3,length(t_s));

% Simulating the fault
% effectiveness of actuators
% effectiveness before fault
eff_matr_normal = diag([1 1 1]);
% effectives after faultt
eff_matr_fault = diag([0.25 1 1]);

effect_actuators = cat(3, repmat(eff_matr_normal,[1 1 t_f(1) - 1]), repmat(eff_matr_fault,[1 1 length(t_f)]));

control_input = zeros(3, length(t_s));
for i = 1:length(t_s)-1 
control_input(:,i) = effect_actuators(:,:,i) * control_desired(:,i); %+ acc_bias;
end

% Output as numerical data
% faultLabel = [ones(t_f(1)-1,1); 2 * ones(length(t_f),1)];
% Output as string data
faultLabel = vertcat(cellstr(repmat('nominal', t_f(1) - 1, 1)), cellstr(repmat('fault', length(t_f), 1)));

% wind disturbance
wind_ned = [0 0 0]';

% stability derivatives and some other drone specific 
% parameters (such as inertia) are included
configDrone;

%% Numeric integration of attitude and translational motion of drone
for i = 1:length(t_s)-1
    
  % Nonlinear attitude propagation
  % Integration via Runge - Kutta integration Algorithm
  x_real(:,i+1) = rungeKutta4('modelDrone', x_real(:,i), control_input(:,i), wind_ned, ti);
  
  % Sensor simulation
  state_dot = modelDrone(x_real(:, i+1), control_input, wind_ned);
  sensor_sim_out(:,i+1) = sensorMeasSimu(x_real(11:13,i+1), state_dot(11:13), x_real(5:7,i+1), x_real(1:4,i+1));
end