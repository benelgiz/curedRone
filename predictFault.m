function label = predictFault(X) %#codegen
%PREDICFAULT Classify if the flight is in fault or not based on compact 
%   model classificationSVMFault 
%   to generate this compact model saved in mat file. run the row below first
%   saveCompactModel(SVMModel,'classificationSVMFault');
%   PREDICTFAULT classifies the 28-by-28 images in the rows of X using
%   the compact ECOC model in the file classificationSVMFault.mat, and then
%   returns class labels in label.
CompactMdl = loadCompactModel('classificationSVMFault');
label = predict(CompactMdl,X); 
end