function ltas(duration)

    % use the loadwavs function to create a cell array of file paths and
    % another cell array of the actual wav samples. the file paths are not
    % needed here, so we omit them with "~"
    [~, wavdata] = loadwavs;
    
    % we assume that all files have the same sampling rate
    samprate = wavread(wavdata{1});

    % concatenate all the wavs into one long wav file
    corpuswav = concatenatewavs(wavdata);

    % calculate the long term average spectrum
    corpusspectrum = fft(corpuswav);
    
    % create the noise spectrum
    noisespectrum = real(ifft(corpusspectrum));

    % create the noise of specified duration & sampling rate
    
    
    % specify output folder
%    outputFolder = uigetdir(cd,'Select Output Folder');


end
