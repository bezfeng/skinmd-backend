%% Server Analysis Daemon

clear all

addpath lib;

resultsFile = 'data.txt';
imageDir = 'images/';

% load in svm model
load('trainmodels.mat');

disp('Finished loading data');

while 1
    % scan through image folder and generate new decisions for each new
    % image. delete any new images
    tic;
    [results, hasNew] = UpdateImages(imageDir, train_modelBH, train_modelMH);
    
    if (hasNew)
    	disp('Updating image results...');
        % write decisions to file or database
        SaveResults(results, resultsFile);
    	disp(['Time: ' num2str(toc)]);
    end
    pause(2);
end

exit;
