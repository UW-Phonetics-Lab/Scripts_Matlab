% run speech perception experiments using external WAV files

function perceptionExperiment()

    % initialize the GUI
    mainWindow = figure('Visible','off','color',[0.5 0.8 0.5],'pos',[0 0 640 480]);
    setupChoiceText = uicontrol('style','text','units','pixels','pos',[50 350 150 50],'backgroundColor',[1 1 1],'string','do you want to load an existing experiment file, or create a new one?');
    setupChoiceBtn1 = uicontrol('style','pushbutton','string','create new file','pos',[50 250 150 25],'enable','on','callback',@createNewExp);
    setupChoiceBtn2 = uicontrol('style','pushbutton','string','load existing file','pos',[250 250 150 25],'enable','on','callback',@loadOldExp);
    
    function clearSetupChoiceUI()
        set(setupChoiceText,'visible','off');
        set(setupChoiceBtn1,'visible','off');
        set(setupChoiceBtn2,'visible','off');
    end
    
    function createNewExp()
        clearSetupChoiceUI();
        subjCodeLabel = uicontrol('style','text','units','pixels','pos',[200 420 150 50],'string','subject code');
        expCodeLabel = uicontrol('style','text','units','pixels','pos',[200 350 150 50],'string','experiment code');
        inputDurLabel = uicontrol('style','text','units','pixels','pos',[200 280 150 50],'string','subject response window duration (milliseconds)');
        isiLabel = uicontrol('style','text','units','pixels','pos',[200 210 150 50],'string','I.S.I. range in milliseconds (if you want it invariant, enter the same number in both boxes)');
        repetitionsLabel = uicontrol('style','text','units','pixels','pos',[200 140 150 50],'string','Number of repetitions of each stimulus');
        leftRightLabel = uicontrol('style','text','units','pixels','pos',[200 70 150 50],'string','Randomize L/R ?');
        
        subjCode = uicontrol('style','edit','units','pixels','pos',[50 420 150 50]);
        expCode = uicontrol('style','edit','units','pixels','pos',[50 350 150 50]);
        inputDur = uicontrol('style','edit','units','pixels','pos',[50 280 150 50]);
        isiL = uicontrol('style','edit','units','pixels','pos',[50 210 50 50]);
        isiH = uicontrol('style','edit','units','pixels','pos',[120 210 50 50]);
        repetitions = uicontrol('style','edit','units','pixels','pos',[50 140 150 50]);
        leftRightGroup = uibuttongroup('units','pixels','pos',[50 70 350 80]);
        btnStereo = uicontrol('parent',leftRightGroup,'enable','off','style','Radio','tag','stereo','units','pixels','pos',[50 70 150 25],'string','Stereo playback');
        btnRandom = uicontrol('parent',leftRightGroup,'enable','off','style','Radio','tag','random','units','pixels','pos',[50 40 150 25],'string','Randomize L/R');
        btnBalanced = uicontrol('parent',leftRightGroup,'enable','off','style','Radio','tag','balanced','units','pixels','pos',[50 10 150 25],'string','Randomize L/R but ensure balance (doubles # of stimuli)');
        lr = get(leftRightGroup,'SelectedObject','tag');
        newExpSubmitBtn = uicontrol('style','pushbutton','string','finish setup','units','pixels','pos',[300 70 150 50],'callback','newExpChecklist(subjCode,expCode,inputDur,isiL,isiH,repetitions,lr)');
    end


    function newExpChecklist(subjCode,expCode,inputDur,isiL,isiH,repetitions,lr)
        a = str2double(inputDur);
        b = str2double(isiL);
        c = str2double(isiH);
        d = str2double(repetitions);
        % check to make sure they're all positive integers
        if isnan(a) || a<0 || a ~= round(a)
            uiwait(errordlg('input duration must be a positive integer (in milliseconds)','Error'));
        elseif isnan(b) || b<0 || b ~= round(b)
            uiwait(errordlg('minimum inter-stimulus interval must be a positive integer (in milliseconds)','Error'));
        elseif isnan(c) || c<0 || c ~= round(c)
            uiwait(errordlg('maximum inter-stimulus interval must be a positive integer (in milliseconds)','Error'));
        elseif isnan(d) || d<0 || d ~= round(d)
            uiwait(errordlg('number of repetitions must be a positive integer','Error'));
        % check to make sure the text variables are not null
        elseif subjCode == null
            uiwait(errordlg('subject code is blank','Error'));
        elseif expCode == null
            uiwait(errordlg('experiment code is blank','Error'));
        elseif lr == null
            uiwait(errordlg('select a left/right scheme','Error'));
        else
            %write all the experiment parameters to a file
            datestamp = datestr(fix(clock), 30);
            isiString = strcat(num2str(isiL),' - ',num2str(isiH));
            
            codedFilename = strcat(expCode,'_',subjCode,'_',datestamp,'.txt');
            outputFile = fopen(codedFilename, 'w');
            fprintf(outputFile, 'experiment code\t%s\n',expCode);
            fprintf(outputFile, 'subject code:\t%s\n',subjCode);
            fprintf(outputFile, 'inter-stimulus interval range (ms)\t%s\n',isiString);
            fprintf(outputFile, 'user response window duration (ms)\t%i\n',inputDur);
            fprintf(outputFile, 'randomization scheme\t%s\n',lr);
            fprintf(outputFile, 'number of repetitions\t%i\n',repetitions);
            fclose(outputFile);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % need to include the name and location of the stimulus file
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            clearNewExpUI();
            initNewExp();
        end
    end



    function clearNewExpUI()
        set(subjCodeLabel,'visible','off');
        set(expCodeLabel,'visible','off');
        set(inputDurLabel,'visible','off');
        set(isiLabel,'visible','off');
        set(repetitionsLabel,'visible','off');
        set(leftRightLabel,'visible','off');
        set(subjCode,'visible','off');
        set(expCode,'visible','off');
        set(inputDur,'visible','off');
        set(isiL,'visible','off');
        set(isiH,'visible','off');
        set(repetitions,'visible','off');
        set(leftRightGroup,'visible','off');
        set(newExpSubmitBtn,'visible','off');
    end


    function initExp()
        % set the experiment to run using the newly created variables
        % proceed to the "start experiment" UI
    end



    function loadOldExp()
        clearSetupChoiceUI();
        
        % create a UI for uploading an experiment file and a stimulus file
        
    end
    
    
    subjectPrompt = uicontrol('style','text','units','pixels','pos',[50 350 150 30],'backgroundColor',[1 1 1],'string','enter subject code and press Enter/Return');
    subjectCodeBox = uicontrol('style','edit','units','pixels','pos',[50 320 150 30],'backgroundColor',[1 1 1],'callback',@enableStart);
    startButton = uicontrol('style','pushbutton','string','Begin Hearing Test','pos',[50 250 150 25],'enable','off','callback',@showInstr);
    movegui(mainWindow,'center');
    set(mainWindow,'name','Hearing Screening');
    set(mainWindow,'visible','on');

    % the instructional interface
    instr = uicontrol('style','text','pos',[50 310 150 50],'background',[1 1 1],'visible','off','string','You will hear sounds one at a time. Indicate which ear heard the sound.');
    cont = uicontrol('style','pushbutton','pos',[50 280 150 30],'visible','off','string','Play first sound','callback',@startTest);
    
    % the interface for responding to sounds
    btnGroup = uibuttongroup('visible','off','units','pixels','pos',[50 150 350 80],'SelectionChangeFcn',@changeResponse);
    btnL = uicontrol('parent',btnGroup,'enable','off','style','Radio','tag','l','units','pixels','pos',[20 40 150 25],'string','Left');
    btnC = uicontrol('parent',btnGroup,'enable','off','style','Radio','tag','c','units','pixels','pos',[120 40 150 25],'string','Neither/Unsure');
    btnR = uicontrol('parent',btnGroup,'enable','off','style','Radio','tag','r','units','pixels','pos',[270 40 150 25],'string','Right');
    btnS = uicontrol('parent',btnGroup,'enable','off','style','pushbutton','units','pixels','pos',[120 10 100 25],'string','Next sound','callback',@recordResponse);
    set(btnGroup,'SelectedObject',[]);
end