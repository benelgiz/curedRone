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

x_real = zeros(13,length(t_s));
engine_speed = zeros(1,length(t_s));
force_moment = zeros(6,length(t_s));

% initial condition for the states
% xReal = [q0 q1 q2 q3 p q r x_n y_e z_d u_b v_b w_b]';
x_real(:,1) = [1 0 0 0 0 0 0 0 0 0 1e-5 1e-5 1e-5]';
engine_speed(1) = 1e-2;

control_deflections = [0 0 0 0 0]';
% controlTorque = [contAileron1 contAileron2 contElevator1 contElevator2
% contRudder]'

wind_ned = [0 0 0]' ;
% wind_ned .:. [wind_n wind_e wind_d]'

% silinecek
global tho_n nc
engine_specs = [tho_n nc];

% Force and moment values should be first calculated by decommanding line
% 59. Runge Kutta function parameters and arguments should be changed to
% only i.th time data is needed. Right now, both ith and i+1 time values of
% forces and moments are evaluated just to be able to compare with
% simulink. The commented 83 to 89 lines are to save force and moment
% values and then one can utilize the code as is.

force_moment = [force.signals.values'; moment.signals.values'];


for i=1:length(t_s)-1
  % engine speed
  engine_speed(i + 1) = rungeKutta4engine('engineDrone', engine_speed(i), ti);
  % forces and moments
%   force_moment(:,i) = calcForceMoment(x_real(:,i), control_deflections, engine_speed(i), wind_ned);
  
  % Nonlinear attitude propagation
  % Integration via Runge - Kutta integration Algorithm
  x_real(:,i+1) = rungeKutta4drone('modelDrone', x_real(:,i), force_moment(:,i),force_moment(:,i+1), ti); 
end

% for comparison via validation.mdl
transPosition.signals.values = [x_real(8,:); x_real(9,:); x_real(10,:)]';
transPosition.time = t_s;
transPosition.signals.dimensions = 3;

[pisi teta fi] = quat2angle([x_real(1,:)' x_real(2,:)' x_real(3,:)' x_real(4,:)']);
eulerAngles.signals.values = [fi teta pisi];
eulerAngles.time = t_s;
eulerangles.signals.dimensions = 3;
fi = rad2deg(fi);
pisi = rad2deg(pisi);
teta = rad2deg(teta);

angVelocity.signals.values = [x_real(5,:); x_real(6,:); x_real(7,:)]';
angVelocity.time = t_s;
angVelocity.signals.dimensions = 3;

transVelocity.signals.values = [x_real(11,:); x_real(12,:); x_real(13,:)]';
transVelocity.time = t_s;
transVelocity.signals.dimensions = 3;
% force.signals.values = force_moment(1:3,:)';
% force.time = t_s;
% force.signals.dimensions = 3;
% 
% moment.signals.values = force_moment(4:6,:)';
% moment.time = t_s;
% moment.signals.dimensions = 3;