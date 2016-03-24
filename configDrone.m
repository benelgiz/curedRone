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

clear all;
clc;

global g_e mass inert wing_tot_surf wing_span m_wing_chord prop_dia nc tho_n cl_alpha1 cl_ele1 cl_p 
global cl_r cl_beta cm_1 cm_alpha1 cm_ele1 cm_q cm_alpha cn_rud_contr cn_r_tilda cn_beta cx1 
global cx_alpha cx_alpha2 cx_beta2 cz_alpha cz1 cy1 cft1 cft2 cft3

% Earth gravitational constant
g_e = 9.81;

% UAV mass [kg]
mass = 28;

% UAV inertia matrix [kg*m^2]
inert = [2.56 0 0.5; 0 10.9 0; 0.5 0 11.3];

% wing total surface S [m^2]
wing_tot_surf = 1.8;

% wing span b [m]
wing_span = 3.1;

% mean aerodynamic wing chord c [m]
m_wing_chord = 0.58;

% diameter of the propeller prop_dia [m]
prop_dia = 0.79;

% engine speed reference signal nc 
nc = 300;

% time constant of the engine tho_n [s]
tho_n = 0.4;

% roll derivatives 
cl_alpha1 = - 3.395e-2;% cl_alpha2 = - clalpha1
cl_ele1 = - 0.485e-2;% cl_ele2   = - clele1
cl_p = - 1.92e-1;
cl_r = 3.61e-2;
cl_beta = - 1.3e-2;

% pitch derivatives
cm_1 = 2.08e-2;
cm_alpha1 = 0.389e-1;% cmalpha2 = cmalpha1
cm_ele1 = 2.725e-1;% cmele2 = cmele1
cm_q = -9.83;
cm_alpha = -9.03e-2;

% yaw derivatives
cn_rud_contr = 5.34e-2;
cn_r_tilda = -2.14e-1;
cn_beta = 8.67e-2;

% lift, drag, side force derivatives
cx1 = -2.12e-2;
cx_alpha = -2.66e-2;
cx_alpha2 = -1.55;
cx_beta2 = -4.01e-1;
cz_alpha = -3.25;
cz1 = 1.29e-2;
cy1 = -3.79e-1;

% thrust derivatives 
cft1 = 8.42e-2;
cft2 = -1.36e-1;
cft3 = -9.28e-1;