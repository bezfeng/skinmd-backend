function [ result] = process( image, train_modelBH, train_modelMH  )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%% NEED TO access
%train models
%lib
%ABCD final

%% Feature extraction
[std_vector, ftest, diameter, avgrgbD] = ABCD(image)
feat(1, 1) = 1;
feat(1, 2) = std_vector;
feat(1, 3) = ftest;
feat(1, 4) = diameter;
feat(1, 5) = avgrgbD(1, 1);
feat(1, 6) = avgrgbD(1, 2);
feat(1, 7) = avgrgbD(1, 3);

%HOG data set
img = image;
%img = imread(image);
temp = HOG(img);
feat(1, 13:93) = temp';
%% SVM
label = zeros(1,1);
[SVMlabel(1, 1), trash] = svmpredict(label, feat, train_modelMH);
[SVMlabel(1, 2), trash] = svmpredict(label, feat, train_modelBH);

if (SVMlabel(1, 1) == 0 && SVMlabel(1, 2) == 0)
    SVMlabel(1, 3) = 1;
else
    SVMlabel(1, 3) = 0;
end

disp('after svm');
SVMlabel

%% Predictor

if (feat(1, 2) >= 2.33)
    SVMlabel(1, 1) = SVMlabel(1, 1) + 2;
    SVMlabel(1, 2) = SVMlabel(1, 2) + 1;
end

if(feat(1, 2) > 10)
    SVMlabel(1, 1) = SVMlabel(1, 1) + 3;
    SVMlabel(1, 2) = SVMlabel(1, 2) + 3;
end

if (feat(1, 3)  == 1)
    SVMlabel(1, 1) = SVMlabel(1, 1) + 3;
    SVMlabel(1, 2) = SVMlabel(1, 2) + 3;
end

%Diameter
if (feat(1, 4) >0.486) && (feat(1, 4)< 3.3)
    SVMlabel(1, 1) = SVMlabel(1, 1) + 1;
    SVMlabel(1, 2) = SVMlabel(1, 2) + 1;
end

if (feat(1, 4) >= 3.3) 
   % SVMlabel(1, 1) = SVMlabel(1, 1) + 3;
end

if (feat(1, 4) < 1.5)
    SVMlabel(1, 3) = SVMlabel(1,3) + 10;
end
%Ratios: #3 - G/R
if (feat(1, 6)/feat(1, 5) > 0.1) && (feat(1, 6)/feat(1, 5) < 0.5)
    SVMlabel(1, 3) = SVMlabel(1, 3) + 2;
    SVMlabel(1, 2) = SVMlabel(1, 2) + 2; 
end

if (feat(1, 6)/feat(1, 5) > 1)
    SVMlabel(1, 1) = SVMlabel(1, 1) + 2;
end

%Ratios: #5 - B/R
if (feat(1, 7)/feat(1, 5) > 0.1) && (feat(1, 7)/feat(1, 5) < 0.5)
    SVMlabel(1, 3) = SVMlabel(1, 3) + 1;
    SVMlabel(1, 2) = SVMlabel(1, 2) + 1; 
end

if (feat(1, 7)/feat(1, 5) > 1)
    SVMlabel(1, 1) = SVMlabel(1, 1) + 2;
end

%Comparisons
if(feat(1,6) > feat(1, 5) || feat(1, 7) > feat(1, 5))
    SVMlabel(1, 1) = SVMlabel(1, 1) + 3;
end

if(feat(1, 7) > feat(1, 6))
    SVMlabel(1, 1) = SVMlabel(1, 1) + 3;
    SVMlabel(1, 2) = SVMlabel(1, 2) + 3;   
end

% Sum

disp('just before prediction');
SVMlabel

[trash, index] = max(SVMlabel(1, :));
result = index;

if(SVMlabel(1, 1) > 10 && SVMlabel(1, 2) > 10)
    result = 4; 
end
%%
end

