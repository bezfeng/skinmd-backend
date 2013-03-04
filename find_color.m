function [avgrgb] = find_color(img, BWfinal)
%% 
%avgrgb = colour values for all 3 channels (rgb) for diseased area

%% Extract out region from original image

img = double(img);

%split color channels
r_targ = img(:, :, 1);
g_targ = img(:, :, 2);
b_targ = img(:, :, 3);

%mask non target areas in channels if there has been edge detection
if length(BWfinal) > 100    
    r_targ(~BWfinal) = 0;
    g_targ(~BWfinal) = 0;
    b_targ(~BWfinal) = 0;
end

%recombine channels
f_targ(:, :, 1) = r_targ;
f_targ(:, :, 2) = g_targ;
f_targ(:, :, 3) = b_targ;

%% Calculate average intensity and stdev for each channel

[trash, trash, v_r] = find(f_targ(:, :, 1));
[trash, trash, v_g] = find(f_targ(:, :, 2));
[trash, trash, v_b] = find(f_targ(:, :, 3));

avgrgb = [mean(v_r), mean(v_g), mean(v_b)];
