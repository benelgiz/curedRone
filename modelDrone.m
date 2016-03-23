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

% inputs : stateInitial .:. States from the previous time t - 1. 
%          VT .:. total airspeed of the aircraft
%          conAil1, conAil2, conEle1,conEle2, conRud .:. controlTorques  

% Attitude dynamic equations of motion 

function state_dot = modelDrone(state_init, flig_cond, con_torq)

global g_e mass inert wing_tot_surf wing_span m_wing_chord cl_alpha1 cl_ele1 cl_p cl_r
global cl_beta cm_1 cm_alpha1 cm_ele1 cm_q cm_alpha cn_rud_contr cn_r_tilda cn_beta cx1 cz_alpha
global cz1 cy1

p = state_init(1);
q = state_init(2);
r = state_init(3);
alph = state_init(4);
bet  = state_init(5);

con_ail1 = con_torq(1);
con_ail2 = con_torq(2);
con_ele1 = con_torq(3);
con_ele2 = con_torq(4);
con_rud  = con_torq(5);

vt = flig_cond(1); % Total airspeed of drone
altitude = flig_cond(2); % altitude

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

p_tilda = wing_span * p / 2 / vt;
r_tilda = wing_span * r / 2 / vt;
q_tilda = m_wing_chord * q / 2 / vt;

% calculation of aerodynamic derivatives
% (In the equations % CLalpha2 = - CLalpha1 and so on used not to inject new names to namespace)

cl = cl_alpha1 * con_ail1 - cl_alpha1 * con_ail2 + cl_ele1 * con_ele1 - cl_ele1 * con_ele2 ...
    + cl_p * p_tilda + cl_r * r_tilda + cl_beta * bet;
cm = cm_1 + cm_alpha1 * con_ail1 + cm_alpha1 * con_ail2 + cm_ele1 * con_ele1 + cm_ele1 * con_ele2 ...
    + cm_q * q_tilda + cm_alpha * alph;
cn = cn_rud_contr * con_rud + cn_r_tilda * r_tilda + cn_beta * bet;

l = dyn_pressure * wing_tot_surf * wing_span * cl;
m = dyn_pressure * wing_tot_surf * m_wing_chord * cm;
n = dyn_pressure * wing_tot_surf * wing_span * cn;

% Dynamical equations of motion of the drone

% Skew symmetric matrix is used for cross product
pqr_dot = inert \ ([l m n]' - [ 0 -r q; r 0 -p;-q p 0] * inert * [p q r]');
alpha_dot = q + g_e / vt * (1 + dyn_pressure * wing_tot_surf / mass / ...
    g_e * ((cx1 + cz_alpha) * alph + cz1));
beta_dot = - r + dyn_pressure * wing_tot_surf * cy1 / mass / vt * bet;

state_dot = [pqr_dot; alpha_dot; beta_dot];