function [pathlist, wavdata] = loadwavs()

    % load in list of wav file paths
    [fileNameArray,fileFolderPath,~] = uigetfile('*.wav','Select WAV files','MultiSelect','on');
    pathlist = cell(size(fileNameArray));
    
    for i=1:length(fileNameArray)
        % convert the list of stimulus filenames into full file paths
        pathlist{i} = strcat(fileFolderPath,fileNameArray{i});
    end
    
    % preallocate the wav data cell array
    wavdata = cell(size(pathlist));
    
    % Read each wav file into the cell array
    for j=1:length(pathlist)
        wavdata{j} = wavread(pathlist{j});
    end

end