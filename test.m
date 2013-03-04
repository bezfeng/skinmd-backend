addpath lib
load trainmodels
I = imread('processed/heal5.jpg');
process(I, train_modelBH, train_modelMH)