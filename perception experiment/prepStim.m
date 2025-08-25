function currentStim = prepStim(fullStimMatr,trialNum)
    % the audio data vector
    tempStimL = fullStimMatr(:,trialNum,1);
    tempStimR = fullStimMatr(:,trialNum,2);

    if isempty(find(isnan(tempStimL),1,'first'))
    % the audio vector goes all the way to the end of the file
        a = length(tempStimL)+1;
    else
    % truncate the audio vector just before the first NaN
        a = find(isnan(tempStimL(:,1)),1,'first');
    end
    currentStim(:,1) = tempStimL(1:a-1,1);
    currentStim(:,2) = tempStimR(1:a-1,1);
