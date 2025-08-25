% head comment here
function perceptionExperiment()

    % display variables
    screenSize = get(0, 'ScreenSize');
    w = screenSize(3); % W-idth (horizontal)
    v = screenSize(4); % V-ertical (height)
    topCenter = [0.1*w 0.9*v 0.8*w 0.2*v]; % 80% of width, 20% of height, 10% in from top edge
    txtPos = [0.1*w 0.4*v 0.8*w 0.2*v]; % 80% of width, 20% of height, centered
    btnPos = [0.5*w 0.2*v 200 25]; % 200w x 25h, at 50%w /20%h
    ltGreen = [0.5 0.8 0.5];
    
% THE MAIN GUI
    mainMenuGroup = uipanel('title',' What do you want to do? ','backgroundcolor',ltGreen,'units','pixels','pos',topCenter);
    setupExpBtn = uicontrol('parent',mainMenuGroup,'style','pushbutton','pos',[50 200 200 30],'string','Set up experiment');
    runExpBtn = uicontrol('parent',mainMenuGroup,'style','pushbutton','pos',[50 150 200 30],'string','Run experiment');
    scoreExpBtn = uicontrol('parent',mainMenuGroup,'style','pushbutton','pos',[50 100 200 30],'string','Score experiment');
    quitProgBtn = uicontrol('parent',mainMenuGroup,'style','pushbutton','pos',[50 50 200 30],'string','Exit program');

% SETUP STIMULI GUI
    setupStimTypeGroup = uipanel('title','What kind of stimuli do you have?','backgroundcolor',ltGreen,'units','pixels','pos',topCenter);
    stimTypeAu = uicontrol('parent',setupStimTypeGroup,'style','checkbox','pos',[50 120 100 30],'string','Audio (WAV files)');
    stimTypeIm = uicontrol('parent',setupStimTypeGroup,'style','checkbox','pos',[50 90 100 30],'string','Images (JPG or PNG files)');
    stimTypeTx = uicontrol('parent',setupStimTypeGroup,'style','checkbox','pos',[50 60 100 30],'string','Text');
    NextBtn = uicontrol('parent',setupStimTypeGroup,'style','pushbutton','pos',[50 30 200 30],'string','Next');
    
% SETUP CORRELATION GUI
    setupCorrelationGroup = uipanel('title','How are stimuli correlated?','backgroundcolor',ltGreen,'units','pixels','pos',topCenter);
    correlFull = uicontrol('parent',setupResponseGroup,'style','radio','pos',[50 120 100 30],'string','Don''t collect responses');
    correl = uicontrol('parent',setupResponseGroup,'style','radio','pos',[50 90 100 30],'string','Forced choice:');
    responseFcCount = uicontrol('enable','off','parent',setupResponseGroup,'style','edit','units','pixels','pos',[160 90 100 30],'backgroundColor',[1 1 1],'tag','fcCount');
    
% SETUP RESPONSES GUI
    setupResponsesGroup = uipanel('title','How will user responses be handled?','backgroundcolor',ltGreen,'units','pixels','pos',topCenter);
    responseNone = uicontrol('parent',setupResponseGroup,'style','radio','pos',[50 120 100 30],'string','Don''t collect responses');
    responseForc = uicontrol('parent',setupResponseGroup,'style','radio','pos',[50 90 100 30],'string','Forced choice:');
    responseFcCount = uicontrol('enable','off','parent',setupResponseGroup,'style','edit','units','pixels','pos',[160 90 100 30],'backgroundColor',[1 1 1],'tag','fcCount');
    
% SET GUI CALLBACKS
    set(setupExpBtn,'callback',@XXX);
    set(runExpBtn,'callback',@XXX);
    set(scoreExpBtn,'callback',@XXX);
    set(quitProgBtn,'callback',@quitProg);
    
    set(setupStimBtn,'callback',{@switchGUI,mainGUI,stimGUI});
    set(setupExpBtn,'callback',{@switchGUI,mainGUI,paraGUI});
    set(runExpBtn,'callback',{@switchGUI,mainGUI,loadGUI});
    set(finalSubmitBtn,'callback',{@switchGUI,finalGUI,mainGUI});
    set(paraBackBtn,'callback',{@switchGUI,paraGUI,mainGUI});
    set(stimsBackBtn,'callback',{@switchGUI,stimGUI,mainGUI});
    set(loadBackBtn,'callback',{@switchGUI,loadGUI,mainGUI});
    
    
    % global variables - experimental parameters
    expCode = '';
    subCode = '';
    isiLo = 0;
    isiHi = 0;
    pauses = 0;
    repetitions = 0;
    inputDur = -1;
    inputScheme = '';
    
    % global variables - other
    stimNameArray = [];
    stimFolderPath = '';
    stimList = {};
    fullStimList = [];
    fullStimMatr = [];
    userResponse = [];
    outputLog = [];
    sampRate = 0;
    trialNum = 0;
    responseTimer = NaN;

    % main window for experiment GUI
    experimentWindow = figure('color',ltGreen);
    set(experimentWindow,'pos', [0 0 w v]);
    
% % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% VISUAL ELEMENTS OF THE VARIOUS GUIs
% % % % % % % % % % % % % % % % % % % % % % % % % % % % %

    % main menu
%    mainGroup = uipanel('title',' What do you want to do? ','backgroundcolor',ltGreen,'units','pixels','pos',[50 50 300 300]);
%    setupStimBtn = uicontrol('parent',mainGroup,'style','pushbutton','pos',[50 200 200 30],'string','Create stimuli list');
%    setupExpBtn = uicontrol('parent',mainGroup,'style','pushbutton','pos',[50 150 200 30],'string','Create parameter file');
%    runExpBtn = uicontrol('parent',mainGroup,'style','pushbutton','pos',[50 100 200 30],'string','Run Experiment');
%    quitProgBtn = uicontrol('parent',mainGroup,'style','pushbutton','pos',[50 50 200 30],'string','Exit Program','callback',@quitProg);

    % experiment ID
    expIDGroup = uipanel('title',' Experiment Identification Codes ','backgroundcolor',ltGreen,'units','pixels','pos',[50 830 500 100]);
    subCodeBox = uicontrol('parent',expIDGroup,'style','edit','units','pixels','pos',[10 50 90 25],'backgroundColor',[1 1 1]);
    expCodeBox = uicontrol('parent',expIDGroup,'style','edit','units','pixels','pos',[10 10 90 25],'backgroundColor',[1 1 1]);
    subCodeLabel = uicontrol('parent',expIDGroup,'style','text','units','pixels','pos',[110 45 250 25],'backgroundcolor',ltGreen,'horizontalAlignment','left','string','Subject code');
    expCodeLabel = uicontrol('parent',expIDGroup,'style','text','units','pixels','pos',[110 5 250 25],'backgroundcolor',ltGreen,'horizontalAlignment','left','string','Experiment code');
    
    % experimental setup parameters
    basicGroup = uipanel('title',' Basic Parameters ','backgroundcolor',ltGreen,'units','pixels','pos',[50 600 500 210]);
    isiLoBox = uicontrol('parent',basicGroup,'style','edit','units','pixels','pos',[10 160 90 25],'backgroundColor',[1 1 1],'tag','Min. ISI');
    isiHiBox = uicontrol('parent',basicGroup,'style','edit','units','pixels','pos',[10 110 90 25],'backgroundColor',[1 1 1],'tag','Max. ISI');
    repeatBox = uicontrol('parent',basicGroup,'style','edit','units','pixels','pos',[10 60 90 25],'backgroundColor',[1 1 1],'tag','Num. repetitions');
    pausesBox = uicontrol('parent',basicGroup,'style','edit','units','pixels','pos',[100 10 90 25],'backgroundColor',[1 1 1],'tag','Num. pauses');
    
    isiLoLabel = uicontrol('parent',basicGroup,'style','text','units','pixels','pos',[110 155 250 25],'backgroundcolor',ltGreen,'horizontalAlignment','left','string','minimum inter-stimulus interval (ms)');
    isiHiLabel = uicontrol('parent',basicGroup,'style','text','units','pixels','pos',[110 105 250 25],'backgroundcolor',ltGreen,'horizontalAlignment','left','string','maximum inter-stimulus interval (ms)');
    repeatLabel = uicontrol('parent',basicGroup,'style','text','units','pixels','pos',[110 55 250 25],'backgroundcolor',ltGreen,'horizontalAlignment','left','string','number of repetitions of each stimulus');
    pause1Label = uicontrol('parent',basicGroup,'style','text','units','pixels','pos',[10 5 80 25],'backgroundcolor',ltGreen,'horizontalAlignment','left','string','pause every');
    pause2Label = uicontrol('parent',basicGroup,'style','text','units','pixels','pos',[200 5 250 25],'backgroundcolor',ltGreen,'horizontalAlignment','left','string','stimuli (0 means no pauses)');
    
    lrGroup = uibuttongroup('title',' Left/Right Scheme ','backgroundcolor',ltGreen,'units','pixels','pos',[50 350 600 230]);
    uicontrol('parent',lrGroup,'style','Radio','tag','stereo','units','pixels','pos',[20 155 550 25],'string','Stereo: the stimuli are already two-channel');
    uicontrol('parent',lrGroup,'style','Radio','tag','mono','units','pixels','pos',[20 125 550 25],'string','Mono > Stereo: play mono stimuli to both ears simultaneously','value',1);
    uicontrol('parent',lrGroup,'style','Radio','tag','random','units','pixels','pos',[20 95 550 25],'string','Mono > Random: mono stimuli will randomly play in left or right ear');
    uicontrol('parent',lrGroup,'style','Radio','tag','balanced','units','pixels','pos',[20 65 550 25],'string','Mono > Balanced: half of mono stimuli played to left ear, half played to right ear');
    uicontrol('parent',lrGroup,'style','Radio','tag','mirrored','units','pixels','pos',[20 35 550 25],'string','Mono > Mirrored: each mono stimulus played to both left and right ears in separate trials');
    uicontrol('parent',lrGroup,'style','text','backgroundcolor',ltGreen,'horizontalAlignment','left','units','pixels','pos',[142 10 400 25],'string','(note: this option requires an even number for "repetitions" above)');
    
    randGroup = uibuttongroup('title',' Randomization Scheme ','backgroundcolor',ltGreen,'units','pixels','pos',[50 200 600 130]);
    uicontrol('parent',randGroup,'style','Radio','tag','none','units','pixels','pos',[20 70 750 25],'string','Do not randomize (play stimuli in the order presented in the stimulus file)');
    uicontrol('parent',randGroup,'style','Radio','tag','full','units','pixels','pos',[20 40 750 25],'string','Fully randomize stimulus order across the whole session');
    uicontrol('parent',randGroup,'style','Radio','tag','block','units','pixels','pos',[20 10 750 25],'string','Randomize within blocks (play each stimulus once before repeating any)');
    
    inputGroup = uibuttongroup('title',' User Input Scheme ','backgroundcolor',ltGreen,'units','pixels','pos',[50 50 600 130],'SelectionChangeFcn',@inputSchemeChange);
    uicontrol('parent',inputGroup,'style','Radio','tag','infinite','units','pixels','pos',[20 70 550 30],'string','Infinite: system waits for response before continuing');
    uicontrol('parent',inputGroup,'style','Radio','tag','timeout','units','pixels','pos',[20 40 550 30],'string','Fixed Timeout: next stimulus plays after specified duration (plus any I.S.I. set above)');
    timeoutTxt = uicontrol('enable','off','parent',inputGroup,'style','text','units','pixels','pos',[20 5 130 25],'backgroundcolor',ltGreen,'horizontalAlignment','left','string','timeout duration (ms):');
    timeoutBox = uicontrol('enable','off','parent',inputGroup,'style','edit','units','pixels','pos',[160 10 90 25],'backgroundColor',[1 1 1],'tag','timeout');
        
    paraSubmitBtn = uicontrol('style','pushbutton','pos',[750 50 75 25],'string','Submit','callback',@submitParamFields);
    paraBackBtn = uicontrol('style','pushbutton','pos',[650 50 75 25],'string','Cancel');
    
    % stimuli file creation
    stimsLabel = uicontrol('style','text','units','pixels','pos',[50 800 250 25],'backgroundColor',ltGreen,'string','Select the stimuli (.wav files only)');
    stimsDisplay = uicontrol('style','text','units','pixels','pos',[50 50 w-100 750],'backgroundColor',ltGreen,'string','','horizontalAlignment','left');
    stimsBrowseBtn = uicontrol('style','pushbutton','pos',[300 800 125 25],'string','Browse...','callback',@browseStims);
    stimsSubmitBtn = uicontrol('style','pushbutton','pos',[600 800 125 25],'string','Submit','callback',@submitStims);
    stimsBackBtn = uicontrol('style','pushbutton','pos',[450 800 125 25],'string','Cancel');
    
    % load parameter and stimuli file screen
    expFileLabel = uicontrol('style','text','units','pixels','pos',[50 300 150 25],'backgroundColor',ltGreen,'string','Path to experiment file:');
    stimFileLabel = uicontrol('style','text','units','pixels','pos',[50 250 150 25],'backgroundColor',ltGreen,'string','Path to stimulus list:');
    expFilePath = uicontrol('style','edit','units','pixels','pos',[210 305 250 25],'backgroundColor',[1 1 1]);
    stimFilePath = uicontrol('style','edit','units','pixels','pos',[210 255 250 25],'backgroundColor',[1 1 1]);
    expFileBtn = uicontrol('style','pushbutton','pos',[470 305 125 25],'string','Browse...','callback',@browseExpFile);
    stimFileBtn = uicontrol('style','pushbutton','pos',[470 255 125 25],'string','Browse...','callback',@browseStimFile);
    loadSubmitBtn = uicontrol('style','pushbutton','pos',[350 150 125 25],'string','start experiment','callback',@checkLoadFields);
    loadBackBtn = uicontrol('style','pushbutton','pos',[210 150 125 25],'string','Cancel');
    
    % preload state
    preloadLabel = uicontrol('style','text','units','pixels','pos',txtPos,'backgroundColor',ltGreen,'string','Preloading stimuli');
    
    % ready state
    readyLabel = uicontrol('style','text','units','pixels','pos',txtPos,'backgroundColor',ltGreen,'string','Click button to begin experiment.');
    readySubmitBtn = uicontrol('style','pushbutton','pos',btnPos,'string','Start','callback',@runExp);
    
    % testing state
    testLabel = uicontrol('style','text','units','pixels','pos',txtPos,'backgroundColor',ltGreen,'string','');
    testSubmitBtn = uicontrol('style','pushbutton','pos',btnPos,'string','Next','callback',{@playNextStim,trialNum});

    % pause state
    pauseLabel = uicontrol('style','text','units','pixels','pos',txtPos,'backgroundColor',ltGreen,'string','Break. Experiment paused. Click button to continue.');
    pauseSubmitBtn = uicontrol('style','pushbutton','pos',btnPos,'string','Continue','callback',{@unpause,trialNum});
    
    % output state
    outputLabel = uicontrol('style','text','units','pixels','pos',txtPos,'backgroundColor',ltGreen,'string','Writing output file, please wait...');
    
    % finished state
    finalLabel = uicontrol('style','text','units','pixels','pos',txtPos,'backgroundColor',ltGreen,'string','Experiment concluded. Thank you! Click button to end.');
    finalSubmitBtn = uicontrol('style','pushbutton','pos',btnPos,'string','Close');

    % these vectors collect all the GUI elements into related groups so
    % that they can be hidden/shown en masse
    mainGUI = mainMenuGroup;
    stimGUI = [expIDGroup,stimsLabel,stimsDisplay,stimsBrowseBtn,stimsSubmitBtn,stimsBackBtn];
    paraGUI = [expIDGroup,basicGroup,lrGroup,randGroup,inputGroup,paraSubmitBtn,paraBackBtn];
    loadGUI = [expFileLabel,stimFileLabel,expFilePath,stimFilePath,expFileBtn,stimFileBtn,loadSubmitBtn,loadBackBtn];
    preloadGUI = preloadLabel;
    readyGUI = [readyLabel,readySubmitBtn];
    testGUI = [testLabel,testSubmitBtn];
    choiceGUI = [];
    pauseGUI = [pauseLabel,pauseSubmitBtn];
    outputGUI = outputLabel;
    finalGUI = [finalLabel,finalSubmitBtn];
    
    % set the callbacks now that the GUI groups have been created
    set(setupStimBtn,'callback',{@switchGUI,mainGUI,stimGUI});
    set(setupExpBtn,'callback',{@switchGUI,mainGUI,paraGUI});
    set(runExpBtn,'callback',{@switchGUI,mainGUI,loadGUI});
    set(finalSubmitBtn,'callback',{@switchGUI,finalGUI,mainGUI});
    set(paraBackBtn,'callback',{@switchGUI,paraGUI,mainGUI});
    set(stimsBackBtn,'callback',{@switchGUI,stimGUI,mainGUI});
    set(loadBackBtn,'callback',{@switchGUI,loadGUI,mainGUI});
    
    % hide everything except the main menu
    initialState = horzcat(stimGUI,paraGUI,loadGUI,preloadGUI,readyGUI,testGUI,choiceGUI,pauseGUI,outputGUI,finalGUI);
    set(initialState,'visible','off');
    
% % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% FUNCTIONS FOR HANDLING/PARSING FORM DATA
% % % % % % % % % % % % % % % % % % % % % % % % % % % % %

%{
    % respond to user parameter changes
    function lrSchemeChange(~,eventdata)
        lrScheme = get(eventdata.NewValue,'tag');
    end

    % respond to user parameter changes
    function randSchemeChange(~,eventdata)
        randScheme = get(eventdata.NewValue,'tag');
    end
%}
    % respond to user parameter changes
    function inputSchemeChange(~,eventdata)
        if strcmp(get(eventdata.NewValue,'tag'),'infinite') == 1
            set(timeoutBox,'enable','off');
            set(timeoutTxt,'enable','off');
        else
            set(timeoutBox,'enable','on');
            set(timeoutTxt,'enable','on');
        end
    end

    % check that the experiment parameter fields are filled in and proper,
    % and write them to file
    function submitParamFields(~,~)
        subCode = get(subCodeBox, 'string');
        expCode = get(expCodeBox, 'string');
        lrScheme = get(get(lrGroup,'SelectedObject'),'tag');
        randScheme = get(get(randGroup,'SelectedObject'),'tag');
        inputScheme = get(get(inputGroup,'SelectedObject'),'tag');
        
        % this long string of "if... elseif... else" checks for errors in
        % the parameter fields
        if strcmp(subCode,'') == 1
            uiwait(errordlg('subject code cannot be blank','Error','replace'));
        
        elseif strcmp(expCode,'') == 1
            uiwait(errordlg('experiment code cannot be blank','Error','replace'));
        
        elseif isnan(str2double(get(isiLoBox,'string'))) == 1 || str2double(get(isiLoBox,'string')) < 0
            uiwait(errordlg(strcat(get(isiLoBox,'tag'),' must be a positive integer'),'Error','replace'));
        
        elseif isnan(str2double(get(isiHiBox,'string'))) == 1 || str2double(get(isiHiBox,'string')) < str2double(get(isiLoBox,'string'))
            uiwait(errordlg(strcat(get(isiHiBox,'tag'),' must be a positive integer larger than minimum ISI'),'Error','replace'));
        
        elseif isnan(str2double(get(repeatBox,'string'))) == 1 || str2double(get(repeatBox,'string')) < 0
            uiwait(errordlg(strcat(get(repeatBox,'tag'),' must be a positive integer'),'Error','replace'));
        
        elseif isnan(str2double(get(pausesBox,'string'))) == 1 || str2double(get(pausesBox,'string')) < 0
            uiwait(errordlg(strcat(get(pausesBox,'tag'),' must be a positive integer'),'Error','replace'));
            
        elseif strcmp(lrScheme,'mirrored') == 1 && mod(repetitions,2) ~= 0
                uiwait(errordlg(strcat(get(repeatBox,'tag'),' must be a positive even number when left-right scheme is set to "mirrored"'),'Error','replace'));
                
        elseif strcmp(inputScheme,'timeout') == 1
            if isnan(str2double(get(timeoutBox,'string'))) == 1
                uiwait(errordlg(strcat(get(timeoutBox,'tag'),' must be an integer'),'Error','replace'));
            else
                inputDur = str2double(get(timeoutBox,'string'));
            end
            
        else
        % no obvious errors in the parameter fields, so write the
        % parameters to file
            datestamp = datestr(fix(clock), 30);
            isiLo = str2double(get(isiLoBox,'string'));
            isiHi = str2double(get(isiHiBox,'string'));
            isiRange = strcat(num2str(isiLo),' - ',num2str(isiHi));
            repetitions = str2double(get(repeatBox,'string'));
            pauses = str2double(get(pausesBox,'string'));
            if strcmp(inputScheme,'timeout') == 1
                inputScheme2 = strcat(get(timeoutBox,'string'),' ms timeout');
            else
                inputScheme2 = inputScheme;
            end

            % write to text file
            codedFilename = strcat(expCode,'_',subCode,'_',datestamp,'_parameters');
            outputFile = fopen(strcat(codedFilename,'.txt'), 'w');
            fprintf(outputFile, 'experiment code\t%s\n',expCode);
            fprintf(outputFile, 'subject code\t%s\n',subCode);
            fprintf(outputFile, 'inter-stimulus interval range (ms)\t%s\n',isiRange);
            fprintf(outputFile, 'number of repetitions\t%i\n',repetitions);
            fprintf(outputFile, 'pause every __ stimuli\t%i\n',pauses);
            fprintf(outputFile, 'left-right scheme\t%s\n',lrScheme);
            fprintf(outputFile, 'randomization scheme\t%s\n',randScheme);
            fprintf(outputFile, 'input scheme\t%s\n',inputScheme2);
            fprintf(outputFile, 'user response window duration (ms)\t%i\n',inputDur);
            fclose(outputFile);

            %write to MAT file
            save(strcat(codedFilename,'.mat'),'expCode','subCode','isiLo','isiHi','repetitions','pauses','lrScheme','randScheme','inputScheme','inputDur');

            % return to main menu
            switchGUI(NaN,NaN,paraGUI,mainGUI);
        end
    end

    % create stimuli filename array from file browser
    function browseStims(~,~)
        [stimNameArray,stimFolderPath,~] = uigetfile('*.wav','Select the Stimulus File(s)','MultiSelect','on');
        stimList = cell(size(stimNameArray));
        for i=1:length(stimNameArray)
            % convert the list of stimulus filenames into full file paths
            stimList{i} = strcat(stimFolderPath,stimNameArray{i});
        end
        set(stimsDisplay,'string',char(stimList));
    end

    % write stimulus information to MAT and TXT files
    function submitStims(~,~)
        % make sure the subject code and experiment code have been set, and
        % that stimuli have been selected
        a = get(expCodeBox, 'string');
        b = get(subCodeBox, 'string');
        c = get(stimsDisplay, 'string');
        datestamp = datestr(fix(clock), 30);
        if strcmp(a,'') == 1
            uiwait(errordlg('subject code cannot be blank','Error','replace'));
        elseif strcmp(b,'') == 1
            uiwait(errordlg('experiment code cannot be blank','Error','replace'));
        elseif strcmp(c,'') == 1
            uiwait(errordlg('you must select at least one stimulus','Error','replace'));
        else
            % convert the list of stimulus filenames into full file paths
            % and write to text file
            codedFilename = strcat(a,'_',b,'_',datestamp,'_stimuli');
            outputFile = fopen(strcat(codedFilename,'.txt'), 'w');
            fprintf(outputFile, '%s\t%s\n','stimulus number','file path');
            for i=1:length(stimList)
                fprintf(outputFile, '%i\t%s\n',i,stimList{i});
            end
            fclose(outputFile);

            %write to MAT file
            save(strcat(codedFilename,'.mat'),'stimList');

            % return to main menu
            switchGUI(NaN,NaN,stimGUI,mainGUI);
        end
    end

    % browse to the stimulus file
    function browseStimFile(~,~)
        [stimFile stimPath] = uigetfile('*.mat','Select the Stimulus List File');
        set(stimFilePath,'string',strcat(stimPath,stimFile));
    end

    % browse to the parameter file
    function browseExpFile(~,~)
        [expFile expPath] = uigetfile('*.mat','Select the Experimental Parameters File');
        set(expFilePath,'string',strcat(expPath,expFile));
    end

    % check that the fields on the load screen are filled in and proper
    % note that the inputScheme is not immediately used within this
    % function, so it is written to a global variable so it can later be
    % accessed by the playStim() function.
    function inputScheme = checkLoadFields(~,~)
        a = get(expFilePath, 'string');
        b = get(stimFilePath, 'string');
        if strcmp(a,'') == 1
            uiwait(errordlg('no experiment file specified','Error','replace'));
        elseif strcmp(b,'') == 1
            uiwait(errordlg('no stimulus file specified','Error','replace'));
        else
            % attempt to load the files
            [expCode subCode isiLo isiHi repetitions pauses lrScheme randScheme inputScheme inputDur] = loadExpFile(a);
            % 'a' should be a MAT file with the following variables:
            % expCode     (experiment code)
            % subCode     (subject code)
            % isiLo       (interstimulus interval: lower bound)
            % isiHi       (interstimulus interval: upper bound)
            % repetitions (number of times to repeat each stimulus)
            % pauses      (how many stims between pauses/breaks)
            % lrScheme    (play sounds to both ears?)
            % randScheme  (randomization of stimulus presentation order)
            % inputScheme (infinite wait, or timeout?)
            % inputDur    (duration of timeout in ms)
            
            stimList = loadStimFile(b);
            % stimList is a MAT file with a single variable (stimList) that
            % has the following structure: 
            % stimNumber FilePathToStim (numberOfChoices) (responseChoice1) (responseChoice2) ...
            % %%%%%%%%
            % %%%%%%%%
            % NEED TO ADD MORE COMPLICATED PARSING TO THIS, AND THEN SET UP
            % A WAY FOR THE RESPONSE CHOICES TO BE HANDLED
            %
            % SHOULD PROBABLY ALLOW (FORCE?) COLUMN HEADINGS, AND PARSE THEM
            % AND ADD THEM TO THE OUTPUT FILE
            % %%%%%%%%
            % %%%%%%%%
        end
        
        % show the preloading message and preload the stimuli
        switchGUI(NaN,NaN,loadGUI,preloadGUI);
        [numSamp numChan sampRate] = getSampRate(stimList);
        fullStimList = applyExperimentalParameters(repetitions,lrScheme,randScheme,stimList);
        fullStimMatr = preloadStimuli(numSamp,numChan,stimList,fullStimList);
        userResponse = zeros(size(fullStimMatr,2),2);

        % show the "ready to begin" message
        switchGUI(NaN,NaN,preloadGUI,readyGUI);
    end

    function runExp(~,~)
        switchGUI(NaN,NaN,readyGUI,testGUI);
        playNextStim(NaN,NaN,trialNum);
    end

    function playNextStim(~,~,trialNum)
        % iterate trialNum
        trialNum = trialNum+1;
        
        if trialNum > length(fullStimList)
        % the experiment is over.  Write the output file.
            datestamp = datestr(fix(clock), 30);
            switchGUI(NaN,NaN,testGUI,outputGUI);
            outputFile = fopen(strcat(expCode,'_',subCode,'_',datestamp,'_results.txt'), 'w');
            % %%%%%%%%%%%%%%%%
            % %%%%%%%%%%%%%%%%
            % should eventually pull in headers from the stim file when
            % writing the output file (as well as perhaps also writing the
            % response choice options)
            % %%%%%%%%%%%%%%%%
            % %%%%%%%%%%%%%%%%
            fprintf(outputFile,'%s\t','stim presentation order');
            fprintf(outputFile,'%s\t','stim number (as ordered in the original file)');
            fprintf(outputFile,'%s\t','left-right-stereo presentation');
            fprintf(outputFile,'%s\n','subject response');
            for g=1:length(fullStimList)
                fprintf(outputFile,'%i\t',outputLog(g,1));
                fprintf(outputFile,'%i\t',outputLog(g,2));
                fprintf(outputFile,'%i\t',outputLog(g,3));
                fprintf(outputFile,'%i\n',outputLog(g,4));
            end
            fclose(outputFile);
            switchGUI(NaN,NaN,outputGUI,finalGUI);
        else
        % the experiment is not yet over
            if trialNum ~= 1 && mod(trialNum,pauses) == 1
            % time for a pause
                pause(trialNum);
            else
            % not time for a pause
                playStim(trialNum);
            end
        end
    end

    function playStim(trialNum)
        % prepare the stimulus
        currentStim = prepStim(fullStimMatr,trialNum);
        audioStim = audioplayer(currentStim,sampRate);
        % calculate ISI
        isi = 0.001*(isiLo + round(rand(1)*(isiHi-isiLo)));
        % wait for the ISI duration
        isiTimer = timer('StartDelay',isi,'TasksToExecute',1,'TimerFcn',@ignoreUserInput);
        start(isiTimer);
        wait(isiTimer);
        delete(isiTimer);
        
        % play the stimulus
        if strcmp(inputScheme, 'timeout') == 1
        % if the experiment requires a response within a set time window,
        % then start a timer immediately after the stim; in this case the
        % "next" button (a.k.a. testSubmitBtn) should already be hidden.
            responseTimer = timer('startFcn',@showChoices,'TimerFcn',@hideChoices,'TasksToExecute',1,'StartDelay',inputDur*0.001);
            playblocking(audioStim);
            start(responseTimer);
            wait(responseTimer);
        else
        % the experiment allows infinite response time...
            % disable the submit/next button
            changeBtnStatus(0);
        
            % play the sound, blocking code excution until it's done
            playblocking(audioStim);

            % update the callback function of the button with the new
            % trialNum and re-enable the button
            set(testSubmitBtn,'callback',{@playNextStim,trialNum});
            changeBtnStatus(1);
        end
        
        % write the output log with trialNum, stimNum, LRcode, and
        % userResponse(s)
        outputLog(trialNum,1) = trialNum;
        outputLog(trialNum,2) = fullStimList(trialNum,1);
        outputLog(trialNum,3) = fullStimList(trialNum,2);
        if userResponse(trialNum,2) ~= 0 && userResponse(trialNum,2) ~= userResponse(trialNum,1)
        % there were two or more different button presses within the response window
            outputLog(trialNum,4) = 'void';
        else
            outputLog(trialNum,4) = userResponse(trialNum,1);
        end
        
    end

    function changeBtnStatus(a)
        if a == 0
            set(testSubmitBtn,'Enable','off');
        else
            set(testSubmitBtn,'Enable','on');
        end
    end

    function showChoices()
        % show the forced choices
        switchGUI(NaN,NaN,testGUI,choiceGUI);
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
         % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
         % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
        % start listening for responses
        set(experimentWindow,'KeyPressFcn',@acceptUserInput);
    end

    function hideChoices()
        responseTimer = NaN;
        % hide the forced choices
        switchGUI(NaN,NaN,choiceGUI,testGUI);
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
         % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
         % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
        % stop listening for responses
        set(experimentWindow,'KeyPressFcn',@ignoreUserInput);
    end

    function ignoreUserInput(~,~)
        % do nothing. This just exists to prevent keystrokes from getting
        % passed to the command window at times when we don't want to
        % collect user input.
    end

    function acceptUserInput(~,EventData)
        % record responses
        if userResponse(trialNum,1) == 0
        % if the user has not yet responded, record their response
            userResponse(trialNum,1) = EventData.Character;
        else
        % if for some reason they are giving a second response within the
        % designated response time window, record the response in a
        % separate cell.
            userResponse(trialNum,2) = EventData.Character;
        end
    end

    function pause(trialNum)
        switchGUI(NaN,NaN,testGUI,pauseGUI);
        set(pauseSubmitBtn,'Callback',{@unpause,trialNum});
    end

    function unpause(~,~,trialNum)
        switchGUI(NaN,NaN,pauseGUI,testGUI);
        playStim(trialNum);
    end

    function quitProg(~,~)
        close(experimentWindow);
    end

end
