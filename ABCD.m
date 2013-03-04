function [std_vector, ftest, diameter2, avgrgbD] = ABCD(image)
%%
%USE THIS FOR ACTUAL CODE:
% function [final, std_vector, ftest, diameter2, avgrgbD, stdrgbD, sDifference] = ABCD(image)
%final: final decision
%std_vector: shows irregularity of melanoma
%ftest: test1, test2 is the result of a ttest for whether or not the image is
%   assymetrical. if test1 = 1, assymetrical L/R. test2 = 1, assymetrical U/D
%   if either are 1, then ftest = 1
%diameter = diameter of the image
%avgrgbD: colour values for all 3 channels (rgb) for diseased area
%stdrgbD: standard deviation of diseased area
%difference: the difference between the texture of the good area and the
%bad area


%%
%56- work
%57-no, work with edge elimin
%58 - no, work with edge elimin
%59 - no, work with edge elimin
%60 - no, work with edge elimin
%image = 'meltest1.jpg';
%% Passes in Image
%decision = zeros(4, 1);
I = image;
%I = imread(image);
%figure()
%imshow(I)
%CHANGE THIS TO CORESPOND TO THE IMAGES WHEN USING MOBILE
I = imresize(I, [320 480]);

%crop image to get rid of black outline
% h = length(I(:, 1, 1));
% w = length(I(1, :, 1));
% I = I(40:h-40, 40:w-40, :);

%figure(1),imshow(I)

hsv = rgb2hsv(I);
HS = hsv(:,:,1:2);
flat = HS(:, :, 2);
%figure(2), imshow(flat)

% Edge detection
% double pass canny filter
[~, threshold] = edge(flat, 'canny');
BWs = edge(flat, 'canny_old', threshold * 3, 8);
%figure(3), imshow(BWs)

% Dilates image/fills in gaps
se90 = strel('line', 6, 90);
se0 = strel('line', 6, 0);
BWsdil = imdilate(BWs, [se90 se0]);

% Fills in interior gaps/holes in an object
BWdfill = imfill(BWsdil, 'holes');
%figure(4), imshow(BWdfill);

% Removes border objects

BWnobord = imclearborder(BWdfill, 4);
%figure(5), imshow(BWnobord), title('cleared border image');

% Smooths out image/unecessary things around it

seD = strel('disk',4);
%NO BORDER ELIMINATION
%BWfinal = imerode(BWdfill, seD);

%BORDER ELIMINATION
BWfinal = imerode(BWnobord,seD);
%figure(6), imshow(BWfinal), title('segmented image');

% Outlines the perimeter of the image
BWoutline = bwperim(BWfinal);
%figure(6), imshow(BWoutline);

%figure(7), imshow(Segout), title('outlined original image');
[B,L] = bwboundaries(BWoutline,'noholes');

%figure(8); imshow(label2rgb(L, @jet, [.5 .5 .5]))


%% Exit if we don't find any edges
if isempty(B)
%    disp('No atypical skin area detected. Try again.')
   std_vector = 0;
   ftest = 0;
   diameter2 = 0;
   avgrgbD = zeros(1, 3);
   avgrgbD(1, 1) = 0;
   avgrgbD(1, 2) = 0;
   avgrgbD(1, 3) = 0;
   return;
end

%% Aldrin's Code
%Find boundary with largest area

max_area = 0;
target = 0;
for i=1:length(B)
    if(numel(B{i})>max_area)
        max_area = numel(B{i});
        target=i;
    end
end

%% Find Center

% figure(1)
% subplot(2,2,1)
% imshow(I); title('Original Image')
% 
% subplot(2,2,2)
% imshow(Segout); title('Detected Area')
% 
% subplot(2,2,[3 4]); hold on;
% plot(B{target}(:,1),B{target}(:,2))
center_x = mean(B{target}(:,1));
center_y = mean(B{target}(:,2));
% plot(center_x,center_y,'r');
% hold off

%% Find distances of rays coming out from center  
left_vectors   = zeros(length(B{target}),1);
right_vectors  = zeros(length(B{target}),1);
top_vectors    = zeros(length(B{target}),1);
bottom_vectors = zeros(length(B{target}),1);
vectors        = zeros(length(B{target}),1);

for i=1:length(B{target})
    vectors(i)=sqrt((B{target}(i,1)-center_x)^2 + (B{target}(i,2)-center_y)^2);  
    % splitting vectors between left and right
    if(B{target}(i,1)>center_x)
    right_vectors(i)=sqrt((B{target}(i,1)-center_x)^2 + (B{target}(i,2)-center_y)^2);
    else
    left_vectors(i)=sqrt((B{target}(i,1)-center_x)^2 + (B{target}(i,2)-center_y)^2);  
    end
    
    % splitting vectors between top and bottom
    if(B{target}(i,2)>center_y)
    top_vectors(i)=sqrt((B{target}(i,1)-center_x)^2 + (B{target}(i,2)-center_y)^2);
    else
    bottom_vectors(i)=sqrt((B{target}(i,1)-center_x)^2 + (B{target}(i,2)-center_y)^2);  
    end  
    
end

std_vector=std(vectors);

%disp(['The mean vector length is ' num2str(mean_vector)])
%disp(['The standard deviation is ' num2str(std_vector)])

% if(std_vector>3)
%   disp('The border is irregular')
%   decision(2) = 1; % decision for B (border)
% else
%   disp('The border is regular')
% end
% disp('    ***********')

%% Asymmetry down center
left_vectors = left_vectors(left_vectors~=0); % extracts non-zero data
right_vectors = right_vectors(right_vectors~=0);
top_vectors = top_vectors(top_vectors~=0); 
bottom_vectors = bottom_vectors(bottom_vectors~=0);

test1 = ttest2(left_vectors, right_vectors);
test2 = ttest2(top_vectors, bottom_vectors);

if(test1 == 1 || test2 == 1)
%     disp('Area is asymmetrical')
    ftest = 1;
else
%     disp('Area is symmetrical')
    ftest = 0;
end
% disp('    ***********')

%% Lisa's Code
%Finds the properties of each of the objects and picks the largest one
area = regionprops(L, 'FilledArea');
maxArea = area(1,1).FilledArea;
maxObject = 1; 
for i = 1:size(area)
    if area(i,1).FilledArea > maxArea
        maxObject = i;
        maxArea = area(i,1).FilledArea;
    end
end

%% Calculates properties as a percentage of the entire image\
% parea = area(maxObject, 1).FilledArea/numel(BW1);
% pperimeter = perimeter(maxObject, 1).Perimeter/numel(BW1);
% pdiameter = diameter(maxObject, 1).EquivDiameter/numel(BW1);

%% INPUT: size of the total skin area in millimeters
%Size: 58.6*115.2 = 6750.72mm per 153600 pixels --> 22.753pixels/mm
actSize = 22.753; %in mm
area = area(maxObject,1).FilledArea;
diameter2 = sqrt(area/3.14)*2/actSize;
% disp('The size of the melanoma is:');
% disp([num2str(area) 'mm in area']);
% disp([num2str(perimeter) 'mm in circumference']);
% disp([num2str(diameter2) 'mm in diameter']);


%% Diagnosis
% Diameter: anything greater than 6mm
% Area: anything greater than ellipse with the radius of one half diameter
% and one half of 6mm. This helps protect against extremely
% irregularly shaped melanomas

% if((diameter2 > 6)||(area>(pi*0.25*diameter2*6)))
% disp('The size is irregular.');
% decision(4) = 1; % decision for D (diameter)
% else
% disp('The size is normal.');
% end
% disp('    ***********')


%% Bezhou's Code

%% Run color finder
[avgrgbD] = find_color(I, BWfinal);

% if result == 1
%     disp('Skin coloration differs');
%     decision(3) = 1; % decision for C (color)
% else
%     disp('Skin coloration and varigation appear normal');
% end
