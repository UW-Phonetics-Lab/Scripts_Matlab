function runTrials()
    %global variables
    expLog = [];
    paused = 0;
    counter = 0; % steps through the fullStimList
    tempStimList = [];
    fullStimList = [];
    fullStimMatr = [];
    % tempStimList includes repetitions and L/R scheme of the stimuli.
    % Column 1 is stimulus ID number, column 2 is a code for the L/R
    % presentation of the stimulus:
    % -1 = user specified that the stims are stereo
    %  0 = play mono sound to both ears
    %  1 = play mono sound to left ear
    %  2 = play mono sound to right ear
    %
    % fullStimList is a permutation of tempStimList, whose order depends on
    % the randomization scheme selected.
    %
    % fullStimMatr is a 3D array, described more fully in the comments
    % within the "preloadStims" function below.
    % 
    % ultimately tempStimList and fullStimList will have other
    % columns (for forced-choice responses or images/text that goes along
    % with the audio stim)
    
    responseTimer = NaN;
    % this will get instantiated and then reused for each stim (but only in
    % experiments with a fixed response time window)

    % the variables below will all get overwritten by the imported MAT file
    % containing the experimental parameters. But MATLAB requires that they
    % be locally declared rather than imported.
    
% % % % % % % % % % % % % % % % % % % % % % % % % % % %
% FUNCTIONS THAT DO THE CORE WORK OF RUNNING THE EXP
% % % % % % % % % % % % % % % % % % % % % % % % % % % % 

    function checkProg(trialNum) 
        counter = counter + 1;
        if counter == length(fullStimList) + 1;
        % if the counter is at the end, write the output file and show the
        % finished screen.
            outputFile = fopen(strcat(expCode,'_',subCode,'_',datestamp,'_results.txt'), 'w');
            % %%%%%%%%%%%%%%%%
            % %%%%%%%%%%%%%%%%
            % should eventually pull in headers from the stim file when
            % writing the output file (as well as perhaps also writing the
            % response choices)
            % %%%%%%%%%%%%%%%%
            % %%%%%%%%%%%%%%%%
            fprintf(outputFile,'%s\t','stim presentation order');
            fprintf(outputFile,'%s\n','stim number (as ordered in the original file)');
            for g=1:length(tempStimList)
                fprintf(outputFile,'%i\t',expLog(g,1));
                fprintf(outputFile,'%i\n',expLog(g,2));
            end
            fclose(outputFile);
            showFinishedState();
            
        elseif mod(counter,pauses) == 0
        % if it's time for a pause... 
            if paused == 0
            % if it's not already paused, then pause it
                paused = 1;
                showPauseState(trialNum);
            else
            % if it was already paused, unpause and continue
                paused = 0;
                hidePauseState();
                playStim(trialNum);
            end
        else
        % if it wasn't time for a pause, proceed
            playStim(trialNum);
        end
    end

    function playStim(trialNum) 
        currentStim = fullStimMatr(:,trialNum,:);
        
        % truncate the audio vector just before the first NaN
        a = find(isnan(currentStim(:,1,1)),1,'first');
        currentStim = currentStim(1:a-1,:,:);
        audioplayer(currentStim, sampRate);
        
        if strcmp(inputScheme, 'timeout') == 1
        % if the experiment requires a response within a set time window,
        % then start a timer immediately after the stim; in this case the
        % "next" button (a.k.a. genericBtn) should already be hidden.
            responseTimer = timer('startFcn',@showResponseWindow,'TimerFcn',@hideResponseWindow,'TasksToExecute',1,'StartDelay',inputDur*0.001);
            playblocking(audioplayer);
            start(responseTimer);
        else
        % the experiment allows infinite response time...
            % disable the "next" button during the stim
            set(genericBtn,'enable','off');
            % play the sound, blocking code excution until it's done
            playblocking(audioplayer);
            % enable the "next" button
            set(genericBtn,'enable','off');
        end
        % record the trial number and stimulus number. User response is
        % pre-populated with a zero; this helps us detect multiple
        % keystrokes and mark them as errors.
        expLog(counter,1) = counter;
        expLog(counter,2) = currentStimNum;
        expLog(counter,3) = 0;
    end

% % % % % % % % % % % % % % % % % % % % % % % % % % % %
% FUNCTIONS THAT DEAL WITH FORCED CHOICE RESPONSES
% % % % % % % % % % % % % % % % % % % % % % % % % % % % 

    function showResponseWindow()
        % show the forced choices
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
         % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
         % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
         % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
        
        % start listening for responses
        set(experimentWindow,'KeyPressFcn',@acceptUserInput);
    end

    function hideResponseWindow()
        % hide the forced choices
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
         % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
         % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
         % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
        
        % stop listening for responses
        set(experimentWindow,'KeyPressFcn',@ignoreUserInput);
        
        % calculate ISI
        isi = isiLo + round(rand(1)*(isiHi-isiLo));
        
        % wait for the ISI duration
        isiTimer = timer('StartDelay',isi,'TasksToExecute',1,'TimerFcn',@ignoreUserInput);
        start(isiTimer);
        wait(isiTimer);
        delete(isiTimer);
        
        % play the next stim
        playStim(fullStimList(counter));
    end

    function ignoreUserInput(~,~)
        % do nothing. This just exists to prevent keystrokes from getting
        % passed to the command window at times when we don't want to
        % collect user input.
    end

    function acceptUserInput(~,EventData)
        % record responses
        if expLog(counter,3) == 0
        % if the user has not yet responded, record their response
            expLog(counter,3) = EventData.Character;
        else
        % if for some reason they are giving a second response within the
        % designated response time window, record the response in a
        % separate cell.
            expLog(counter,4) = EventData.Character;
        end
    end

end