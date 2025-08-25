function [numSamp numChan sampRate] = getSampRate(stimList)
    % read the first WAV file and determine its number of samples and
    % mono/stereo. Also, assume that all files have the same sample
    % rate and store that number for use during playback.
    numSampChan = wavread(stimList{1},'size');
    numSamp = numSampChan(1);
    numChan = numSampChan(2);
    [~, sampRate] = wavread(stimList{1});


