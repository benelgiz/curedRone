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

% Select the number of classes
classNum = 2;

feature_vec = sensor_sim_out';

% normal = repmat('normal', length(sensor_sim_out_normal'), 1);
% normal = cellstr(normal);
% fault = repmat('fault', length(sensor_sim_out_fault'), 1);
% fault = cellstr(fault);
% output_vec = vertcat(normal, fault);

output_vec = faultLabel;

% %% Arrange training/validation sets
% % 1 fold cross validation
% 
% % feature_vec_training .:. feature matrix for training
% % output_vec_training .:. output vector for training
% 
% % training set (around %70 percent of whole data set)
% trainingDataExNum = ceil(70 / 100 * (length(feature_vec)));
% 
% % Select %70 of data for training and leave the rest for testing
% randomSelectionColoumnNum = randperm(length(feature_vec),trainingDataExNum);
% 
% % Training set for feature and output
% feature_vec_training = feature_vec(randomSelectionColoumnNum, :);
% output_vec_training = output_vec(randomSelectionColoumnNum, :);
% 
% % Test set for feature and output
% feature_vec_validation = feature_vec;
% feature_vec_validation(randomSelectionColoumnNum, :) = [];
% 
% output_vec_validation = output_vec;
% output_vec_validation(randomSelectionColoumnNum, :) = [];

%% TRAINING PHASE

% SVMModel is a trained ClassificationSVM classifier.
tic
SVMModel = fitcsvm(feature_vec,output_vec,'Standardize', true, 'ClassNames',{'nominal','fault'});
toc

% Support vectors
sv = SVMModel.SupportVectors;

ScoreSVMModel = fitPosterior(SVMModel)


%% CROSS VALIDATION
% 10-fold cross validation on the training data
% inputs : trained SVM classifier (which also stores the training data)
% outputs : cross-validated (partitioned) SVM classifier from a trained SVM
% classifier

% CVSVMModel is a ClassificationPartitionedModel cross-validated classifier.
% ClassificationPartitionedModel is a set of classification models trained 
% on cross-validated folds.
CVSVMModel = crossval(SVMModel);

% Assess performance of classification via Matlab tools

% To assess predictive performance of SVMModel on cross-validated data 
% "kfold" methods and properties of CVSVMModel, such as kfoldLoss is used

% Evaluate 10-fold cross-validation error.
% (Estimate the out-of-sample misclassification rate.)

crossValClassificErr = kfoldLoss(CVSVMModel);

% Predict response for observations not used for training
% Estimate cross-validation predicted labels and scores.
[elabel,escore] = kfoldPredict(CVSVMModel);

max(escore)
min(escore)



% [ScoreCVSVMModel,ScoreParameters] = fitSVMPosterior(CVSVMModel);

%% Assess performance of classification via confusion matrix


%% FIT POSTERIOR PROBABILITES firPosterior(SVMModel) / fitSVMPosterior(CVSVMModel)
% "The transformation function computes the posterior probability 
% that an observation is classified into the positive class (SVMModel.Classnames(2)).
% The software fits the appropriate score-to-posterior-probability 
% transformation function using the SVM classifier SVMModel, and 
% by conducting 10-fold cross validation using the stored predictor data (SVMModel.X) 
% and the class labels (SVMModel.Y) as outlined in REF : Platt, J. 
% "Probabilistic outputs for support vector machines and comparisons 
% to regularized likelihood methods". In: Advances in Large Margin Classifiers. 
% Cambridge, MA: The MIT Press, 2000, pp. 61?74"


%% Plot results
figure
gscatter(feature_vec(:,1),feature_vec(:,2),output_vec)
hold on
plot(sv(:,1),sv(:,2),'ko','MarkerSize',10)
% legend('normal','fault','Support Vector')
legend('normal','fault')
hold off
set(legend,'FontSize',11);
xlabel({'$a_x$'},...
'FontUnits','points',...
'interpreter','latex',...
'FontSize',15,...
'FontName','Times')
ylabel({'$a_y$'},...
'FontUnits','points',...
'interpreter','latex',...
'FontSize',15,...
'FontName','Times')
print -depsc2 feat1vsfeat2.eps

%% PREDICTION PHASE
% e = edge(SVMModel, feature_vec_validation, output_vec_validation);
% m = margin(SVMModel, feature_vec_validation, output_vec_validation);
[label,score] = predict(SVMModel,feature_vec);

