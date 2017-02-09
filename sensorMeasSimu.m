% Copyright 2017 Elgiz Baskaya

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

% Attitude kinematic and dynamic equations of motion
% Translational Motion of a drone

% inputs :                v .:. translational velocity vector 
%                               of the drone center of mass
%                               v = [u_b v_b w_b]  
%
%                    v_dot  .:. time derivative of v vector
%                               (this derivation is in body frame) 
%                               v_dot = [u_b_dot v_b_dot w_b_dot]'
%
%                         w .:. describes the angular motion of the body 
%                               frame b with respect to navigation frame 
%                               North East Down(NED), expressed in body frame
%                               w = [p q r]' 
%                         quat .:. quaternions
%                               q = q0 + q1 * i + q2 * j + q3 * k
%
% outputs : sensor_out_sim  .:. simulated sensor measurements -
%                               sensor_out_sim = [acc_out_sim; gyro_out_sim]

function sensor_out_sim = sensorMeasSimu(v, v_dot, w, quat)

global bias_acc std_acc bias_gyro std_gyro

% translational velocity of drone
u_b = v(1);
v_b = v(2);
w_b = v(3);

% angular velocity of the drone
p = w(1);
q = w(2);
r = w(3);

% Quaternions to Euler Angles
% tilda is to ignore output of the quat2angle function, since it is not
% used, a warning appears otherwise
[~, teta, fi] = quat2angle(quat);

% sensor simulations
% accelerometer simulation
acc_out_sim =  (v_dot + [q * w_b - r * v_b + g_e * sin(teta); ...
    r * u_b - p * w_b - g_e * cos(teta) * sin(fi); ...
    p * v_b - q * u_b - g_e * cos(teta) * cos(fi)])  / g_e +  bias_acc + std_acc .* randn(3,1);
% accelerometer simulation
gyro_out_sim = [p q r]' + bias_gyro + std_gyro .* randn(3,1);
sensor_out_sim = [acc_out_sim; gyro_out_sim];