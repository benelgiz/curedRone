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

global g_e inert mass wing_tot_surf wing_span m_wing_chord prop_dia tho_n
global cl_ail cl_p cl_r cl_beta cm_0 cm_ele cm_q cm_alpha cn_ail cn_p cn_r cn_beta 
global cz_0 cz_alpha cz_q cz_ele cy_beta cy_p cy_r cy_ail cx_0 cx_k cft1 cft2 cft_rpm  


% Earth gravitational constant
g_e = 9.81;

% UAV mass [kg]
mass = 1.1;

% inert = [0.0247 0 0; 0 0.0158 0; 0 0 0.0374];
% UAV inertia matrix [kg*m^2]
inert = [0.247 0 0; 0 0.158 0; 0 0 0.374];

% wing total surface S [m^2]
wing_tot_surf = 0.27;

% wing span b [m]
wing_span = 1.288;

% mean aerodynamic wing chord c [m]
m_wing_chord = 0.21;

% diameter of the propeller prop_dia [m]
prop_dia = 0.228;

% time constant of the engine tho_n [s]
tho_n = 0.05;

% roll derivatives 
cl_ail = -0.1956e-2; 
cl_p = -4.095e-1;
cl_r = 6.203e-2;
cl_beta = 3.319e-2;

% pitch derivatives
cm_0 = 0.043; % for now...
cm_ele = -0.076e-1;
cm_q = -1.6834;
cm_alpha = -32.34e-2;

% yaw derivatives
cn_ail = -0.0126e-2;
cn_p = -4.139e-2;
cn_r = -0.1002e-1;
cn_beta = 2.28e-2;

% lift derivatives
cz_0 = -4.7e-2;
cz_alpha = 6.386e-2;
cz_q = 4.8198;
cz_ele = 1.6558e-2;

% side force derivative
cy_beta = -2.708e-1;
cy_p = 1.695e-2;
cy_r = 5.003e-2;
cy_ail = 0.0254e-2;


% drag derivative
cx_0 = 2.313e-2;
cx_k = 1.897e-1; 

% thrust derivatives 
cft1 = 1.342e-1;
cft2 = -1.975e-1;
cft_rpm = 7.048e-6;