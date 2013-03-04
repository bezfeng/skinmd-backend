function [results, hasNew] = UpdateImages(imageDir, train_modelBH, train_modelMH)
    %capture jpg and png files
    sFiles = dir([imageDir '*.jpg']);
    sFiles = [sFiles ; dir([imageDir '*.png'])];

    hasNew = ~isempty(sFiles);
    
    % make a folder to hold processed files if it does not exist
    if (exist('processed', 'dir') == 0)
        mkdir('processed');
    end
    
    if (hasNew)
        disp([num2str(length(sFiles)) ' new files detected']);
        results = cell(length(sFiles), 1);
         
        for i = 1:length(sFiles)
            disp(['Processing: ' sFiles(i).name]);
            % write to results array
            results{i}.name = sFiles(i).name;
            results{i}.date = sFiles(i).date;
            
            % run HOG
            img = imread([imageDir sFiles(i).name]);  
            res = process(img, train_modelBH, train_modelMH);
 
            % results:
            % 0 = healthy (lHVA = 1 and lMVA, lBVA = 0)
            % 1 = Melanoma (lMVA = 1 and lHVA, lBVA = 0)
            % 2 = BCC (lBVA = 1 and lHVA, lMVA = 0)
            % 3 = Undetermined disease (lBVA, lMVA = 1, lHVA = 0)
            % 4 = Unsure (all = 1)
            
            results{i}.res = res;
            % move file to processed folder
              movefile(['images/' sFiles(i).name], ...
                ['processed/' sFiles(i).name]);
        end
    else
        results = cell(1, 1);
    end
end
