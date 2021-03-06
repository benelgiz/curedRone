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

function xn = rungeKutta4(func, xo, cntrl, wind_ned, h)

k1 = feval(func, xo, cntrl, wind_ned);
k2 = feval(func, xo + 1/2 * h * k1, cntrl, wind_ned);
k3 = feval(func, xo + 1/2 * h * k2, cntrl, wind_ned);
k4 = feval(func, xo + h * k3, cntrl, wind_ned);

xn = xo + 1/6 * h * (k1 + 2 * k2 + 2 * k3 + k4);
end