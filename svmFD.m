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

% FAULT DETECTION VIA SVM
% This code assumes that you already have a data set of normal and faulty 
% situation sensor outputs.

classNum = 2;

% training set (around %70 percent of whole data set)

wholeDataSet = [sensor_sim_out_normal'; sensor_sim_out_fault'];
trainingDataExNumForEachClass = ceil(70 / 100 * (length(sensor_sim_out_normal)+length(sensor_sim_out_fault)))/classNum;

sensor_sim_out_normalt = sensor_sim_out_normal';
sensor_sim_out_faultt = sensor_sim_out_fault';

% Select %70 of data for training and leave the rest for testing
randomSelectionColoumnNum = randperm(length(sensor_sim_out_normalt),trainingDataExNumForEachClass);

training_data_normal = sensor_sim_out_normalt(randomSelectionColoumnNum, :);
% test set for the normal class
sensor_sim_out_normalt(randomSelectionColoumnNum, :) = [];

training_data_fault = sensor_sim_out_faultt(randomSelectionColoumnNum, :);
% test set for the faulty class
sensor_sim_out_faultt(randomSelectionColoumnNum, :) = [];

% training data set - %70 of whole data available
training_data = [training_data_normal; training_data_fault];

normal = repmat('normal', length(training_data_normal), 1);
normal = cellstr(normal);
fault = repmat('fault', length(training_data_fault), 1);
fault = cellstr(fault);
status = vertcat(normal, fault);

tic
SVMModel = fitcsvm(training_data,status);
toc

test_data = [sensor_sim_out_normalt; sensor_sim_out_faultt];
[label,score] = predict(SVMModel,test_data);

