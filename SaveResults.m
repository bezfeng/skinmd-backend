function SaveResults(diagRes, diagResFile)
    disp('saving results!');
    
    % open file handle
    fid = fopen(diagResFile, 'a');
    
    % loop through all entries in the results array
    for i = 1:length(diagRes)
       fprintf(fid, '%s,%s,%d\n', diagRes{i}.name, diagRes{i}.date, ...
                                diagRes{i}.res);
    end
    
    % close file
    fclose(fid);
end