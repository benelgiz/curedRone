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

% Attitude kinematic and dynamic equations of motion
% Translational Motion of a drone

% inputs : state_prev  .:. states from the previous time t - 1. 
%                          state_prev = [q0 q1 q2 q3 p q r x_n y_e z_d u_b v_b w_b]'
%                          where;
%                               q = q0 + q1 * i + q2 * j + q3 * k
%                               w .:. describes the angular motion of the body 
%                                     frame b with respect to navigation frame 
%                                     North East Down(NED), expressed in body frame
%                               w = [p q r]' 
%                               x .:. position of the drone in NED
%                               reference frame [m]
%                               x = [x_n y_e z_d]'
%                               v .:. inertial velocity vector of the drone center of mass 
%                               v = [u_b v_b w_b]'
%                                
%          contr_input .:. controller inputs
%                          contr_input = [deflect_ail[degrees] deflect_elev[degrees] engine_speed[rev/s]]'
%
%          wind_ned    .:. wind disturbance in NED frame 
%                          wind_ned = [wind_n wind_e wind_d]'

% outputs : state_dot  .:. time derivative of states

function [state_dot] = modelDrone(state_prev, contr_input, wind_ned)

global g_e inert mass wing_tot_surf wing_span m_wing_chord prop_dia
global cl_ail cl_p cl_r cl_beta cm_0 cm_ele cm_q cm_alpha cn_ail cn_p cn_r cn_beta 
global cz_0 cz_alpha cz_q cz_ele cy_beta cy_p cy_r cy_ail cx_0 cx_k cft1 cft2 cft_rpm

quat_normalize_gain = 1;

% q .:. quaternion
% q = q0 + q1 * i + q2 * j + q3 * k;  
q0 = state_prev(1);
q1 = state_prev(2);
q2 = state_prev(3);
q3 = state_prev(4);

% w .:. angular velocity vector with components p, q, r
% w = [p q r]' 
% w describes the angular motion of the body frame b with respect to
% navigation frame NED, expressed in body frame.
p = state_prev(5);
q = state_prev(6);
r = state_prev(7);

% x .:. position of the drone in NED reference frame
% x = [x_n y_e z_d]';
% x_n = state_prev(8);
% y_e = state_prev(9);
% z_d = state_prev(10);

% v .:. translational velocity of the drone
% v = [u_b v_b w_b]
u_b = state_prev(11);
v_b = state_prev(12);
w_b = state_prev(13);

% Flight altitude
altitude = state_prev(10);

% Control inputs
con_ail = contr_input(1);    % aileron deflection [degrees]
con_ele = contr_input(2);    % elevator deflection [degrees]
eng_speed = contr_input(3);   % engine speed reference signal [rev/s]

% If A is any vector
% A^n = C^n_b * A^b = c_b_to_n * A^b = inv(c_n_to_b) * A^b = c_n_to_b' * A^b
% Direction cosine matrix C^b_n representing the transformation from
% the navigation frame to the body frame
c_n_to_b = [1 - 2 * (q2^2 + q3^2) 2 * (q1 * q2 + q0 * q3) 2 * (q1 * q3 - q0 * q2); ...
2 * (q1 * q2 - q0 * q3) 1 - 2 * (q1^2 + q3^2) 2 * (q2 * q3 + q0 * q1); ...
2 * (q1 * q3 + q0 * q2) 2 * (q2 * q3 - q0 * q1) 1 - 2 * (q1^2 + q2^2)];

vel_t = [u_b; v_b; w_b] - c_n_to_b * wind_ned;

% Total airspeed of drone
vt = sqrt(vel_t(1)^2 + vel_t(2)^2 + vel_t(3)^2);

% alph .:. angle of attack
alph = atan2(vel_t(3),vel_t(1));

% bet .:. side slip angle
bet  = asin(vel_t(2)/vt);

% Low altitude atmosphere model (valid up to 11 km)
% t0 = 288.15; % Temperature [K]
% a_ = - 6.5e-3; % [K/m]
% r_ = 287.3; % [m^2/K/s^2] 
% p0 = 1013e2; %[N/m^2]
% t_= t0 * (1 + a_ * altitude / t0);
% ro = p0 * (1 + a_ * altitute /t0)^5.2561 / r_ / t_;
t_ = 288.15 * (1 - 6.5e-3 * altitude / 288.15);
ro = 1013e2 * (1 - 6.5e-3 * altitude / 288.15)^5.2561 / 287.3 / t_;
dyn_pressure = ro * vt^2 / 2;

% pqr from body to stability axis
c_body_to_stability = [cos(alph) 0 sin(alph); 0 1 0; -sin(alph) 0 cos(alph)];
pqr_stability = c_body_to_stability * [p q r]';

% dimensionless angular rates in stability frame
p_tilda = wing_span * pqr_stability(1) / 2 / vt;
q_tilda = m_wing_chord * pqr_stability(2) / 2 / vt;
r_tilda = wing_span * pqr_stability(3) / 2 / vt;

% calculation of aerodynamic derivatives
cl = cl_ail * con_ail + cl_p * p_tilda + cl_r * r_tilda + cl_beta * bet;
cm = cm_0 + cm_ele * con_ele + cm_q * q_tilda + cm_alpha * alph;
cn = cn_ail * con_ail + cn_p * p_tilda + cn_r * r_tilda + cn_beta * bet;

l = dyn_pressure * wing_tot_surf * wing_span * cl;
m = dyn_pressure * wing_tot_surf * m_wing_chord * cm;
n = dyn_pressure * wing_tot_surf * wing_span * cn;

moment_stabFrame = [l m n]';
moment = c_body_to_stability' * moment_stabFrame;

% tilda is to ignore output of the quat2angle function, since it is not
% used, a warning appears otherwise. output angles are in radians.
[~, teta, fi] = quat2angle([q0 q1 q2 q3]);

% ro * eng_speed^2 * prop_dia^4
% vt / prop_dia / eng_speed/60
% cft_rpm * eng_speed / 60
% ft .:. thrust force 
ft = ro * eng_speed^2 * prop_dia^4 * (cft1 + cft2 * vt / prop_dia / eng_speed + cft_rpm * eng_speed / 60);
% Model of the aerodynamic forces in stability

% dyn_pressure * wing_tot_surf
% % zf_s .:. lift force in stability %MAKO
zf_s = dyn_pressure * wing_tot_surf * (cz_0 + cz_alpha * alph + cz_q * q_tilda + cz_ele * con_ele);

% % yf_s .:. lateral force in stability frame %MAKO
yf_s = dyn_pressure * wing_tot_surf * (cy_beta * bet + cy_p * p_tilda + cy_r * r_tilda + cy_ail * con_ail);

% xf_s .:. drag force in stability frame %MAKO
xf_s = dyn_pressure * wing_tot_surf * (cx_0 + cx_k * (cz_0 + cz_alpha * alph + cz_q * q_tilda + cz_ele * con_ele)^2);

% aerodynamic forces in body frame (transformation from the stability frame)
% attention! Multiplication with minus one comes from the definition of
% forces in the stability frame in AVL (where the stability derivatives are
% calculated)
aero_forces_body = c_body_to_stability' * [-xf_s; yf_s; -zf_s];

force = mass * [- g_e * sin(teta); g_e * sin(fi) * cos(teta); g_e * cos(fi) * cos(teta)] +...
    ([ft; 0; 0] + aero_forces_body);

% Kinematic and dynamic equations of motion of the drone

% Attitude dynamics of drone
% Skew symmetric matrix is used for cross product
pqr_dot = inert \ (moment - [ 0 -r q; r 0 -p; -q p 0] * (inert * [p q r]'));

% Attitude kinematics of drone
q_dot = 1 / 2 * [-q1 -q2 -q3; q0 -q3 q2; q3 q0 -q1; -q2 q1 q0] * [p q r]' ...
    + quat_normalize_gain * (1 - (q0^2 + q1^2 + q2^2 + q3^2)) * [q0 q1 q2 q3]';

% x_dot is in NED frame. So a change in expression of v is needed.
x_dot = c_n_to_b' * [u_b v_b w_b]';

% dynamics for translational motion of the center of mass of the drone
v_dot = force / mass - [(q * w_b - r * v_b); (r * u_b - p * w_b); (p * v_b - q * u_b)];

%state_dot = [q_dot; pqr_dot; x_dot; v_dot; eng_speed_dot];
state_dot = [q_dot; pqr_dot; x_dot; v_dot];