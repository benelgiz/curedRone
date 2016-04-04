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

function euler_ang = quat_to_euler(quater)

euler_ang = [atan2(2 .* (quater(3,:) .* quater(4,:) - quater(1,:) .* quater(2,:)), ...
    2 * ((quater(1,:)).^2  - 1 + (quater(4,:)).^2));...
    - atan((2 * (quater(2,:) .* quater(4,:) + quater(1,:) .* quater(3,:))) ./ sqrt(1 - (2 * (quater(2,:) .* quater(4,:) + quater(1,:) .* quater(3,:))).^2)); ...
    atan2(2 * (quater(2,:) .* quater(3,:) - quater(1,:) .* quater(4,:)), ...
    2 * ((quater(1,:)).^2 - 1 + 2 * (quater(2,:)).^2))]