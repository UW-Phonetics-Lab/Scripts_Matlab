function changeGUI(gui)
    uistack(gui,'top');
    set(gui,'visible','on');
    
    
    % need to create variables for the following figures:
    % setupState
    % preloadState
    % readyState
    % testingState
    % pauseState
    % finishedState

    % also need to deal with the fact that "pauseState" passes a variable
    % that the other states do not.
    
    function showPreloadState()
        set(stimFilePathLabel,'string','Preloading Stimuli');
        set(stimFilePathLabel,'pos',[0.5*w 0.5*v 200 25]);
    end

    function showReadyState()
        delete(stimFilePathLabel);
        set(genericBtn,'visible','on');
        set(genericBtn,'string','Click here to begin');
        set(genericBtn,'callback',@startExp);
        set(genericBtn,'pos',[0.5*w 0.5*v 200 25]);
    end

    function showTestingState()
        if strcmp(inputScheme, 'timeout') == 1
        % if the experiment requires a response within a set time window,
        % then we don't want any "next" button visible
            set(genericBtn,'visible','off');
        else
        % if the experiment waits indefinitely for user response before
        % proceeding, we need the "next" button
            set(genericBtn,'callback',@nextStim);
            set(genericBtn,'string','Next');
            set(genericBtn,'pos',[0.75*w 0.25*v 200 25]);
        end
    end

    function showPauseState(trialNum)
        % show the Pause UI
        uistack(pauseUI,'top');
        uistack(genericBtn,'top');
        set(pauseUI,'visible','on');
        set(genericBtn,'visible','on');
        set(genericBtn,'string','Continue');
        set(genericBtn,'pos',[0.5*w 0.25*v 200 25]);
        set(genericBtn,'callback',{'checkProg',trialNum});
        % % % % % % % % % % % % % % % % % % % % % % % % 
        % THIS LAST LINE MAY BE PROBLEMATIC, AS CALLBACKS AUTOMATICALLY
        % SEND hObject AND EventData ARGUMENTS, WHICH THE checkProg
        % FUNCTION IS NOT SET UP TO ACCEPT. IF IT THROWS AN ERROR, CAN BE
        % FIXED BY CHANGING THE LAST LINE ABOVE TO THIS:
        % set(genericBtn,'callback',@continueExp);
        % AND INSERTING A DUMMY FUNCTION LIKE THIS:
        % function continueExp(~,~,trialNum)
        %     checkProg(trialNum);
        % end
        % % % % % % % % % % % % % % % % % % % % % % % % 
        
    end

    function hidePauseState()
        % remove the Pause UI
        set(pauseUI,'visible','off');
        showTestingState();
    end

    function showFinishedState()
        % show the final UI
        uistack(finalUI,'top');
        uistack(genericBtn,'top');
        set(finalUI,'visible','on');
        set(genericBtn,'visible','on');
        set(genericBtn,'string','Finish');
        set(genericBtn,'pos',[0.5*w 0.25*v 200 25]);
        set(genericBtn,'callback',@endExp);
    end

    function endExp()
        %close the figure window
        close(experimentWindow);
    end
    
    
    
end