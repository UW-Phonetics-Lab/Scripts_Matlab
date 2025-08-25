function setup

% used to set up the raw data

%% set up stimuli data storage

% set up unprocessed data
sr_data.unprocessed.stimuli = NaN(2,64,10);

% set up hilbert data
sr_data.hilbert.stimuli.LPhalf = NaN(2,64,10);
sr_data.hilbert.stimuli.LP1 = NaN(2,64,10);
sr_data.hilbert.stimuli.LP2 = NaN(2,64,10);
sr_data.hilbert.stimuli.LP4 = NaN(2,64,10);
sr_data.hilbert.stimuli.LP8 = NaN(2,64,10);
sr_data.hilbert.stimuli.LP16 = NaN(2,64,10);
sr_data.hilbert.stimuli.LP32 = NaN(2,64,10);
sr_data.hilbert.stimuli.LPinf = NaN(2,64,10);

% set up coherent data
sr_data.coherent.stimuli.LPhalf = NaN(2,64,10);
sr_data.coherent.stimuli.LP1 = NaN(2,64,10);
sr_data.coherent.stimuli.LP2 = NaN(2,64,10);
sr_data.coherent.stimuli.LP4 = NaN(2,64,10);
sr_data.coherent.stimuli.LP8 = NaN(2,64,10);
sr_data.coherent.stimuli.LP16 = NaN(2,64,10);
sr_data.coherent.stimuli.LP32 = NaN(2,64,10);
sr_data.coherent.stimuli.LPinf = NaN(2,64,10);

%% set up talker data storage

% set up unprocessed data
sr_data.unprocessed.talker = NaN(2,64,10);

% set up hilbert data
sr_data.hilbert.talker.LPhalf = NaN(2,64,10);
sr_data.hilbert.talker.LP1 = NaN(2,64,10);
sr_data.hilbert.talker.LP2 = NaN(2,64,10);
sr_data.hilbert.talker.LP4 = NaN(2,64,10);
sr_data.hilbert.talker.LP8 = NaN(2,64,10);
sr_data.hilbert.talker.LP16 = NaN(2,64,10);
sr_data.hilbert.talker.LP32 = NaN(2,64,10);
sr_data.hilbert.talker.LPinf = NaN(2,64,10);

% set up coherent data
sr_data.coherent.talker.LPhalf = NaN(2,64,10);
sr_data.coherent.talker.LP1 = NaN(2,64,10);
sr_data.coherent.talker.LP2 = NaN(2,64,10);
sr_data.coherent.talker.LP4 = NaN(2,64,10);
sr_data.coherent.talker.LP8 = NaN(2,64,10);
sr_data.coherent.talker.LP16 = NaN(2,64,10);
sr_data.coherent.talker.LP32 = NaN(2,64,10);
sr_data.coherent.talker.LPinf = NaN(2,64,10);

%% set up response data storage

% set up unprocessed data
sr_data.unprocessed.response = NaN(2,64,10);

% set up hilbert data
sr_data.hilbert.response.LPhalf = NaN(2,64,10);
sr_data.hilbert.response.LP1 = NaN(2,64,10);
sr_data.hilbert.response.LP2 = NaN(2,64,10);
sr_data.hilbert.response.LP4 = NaN(2,64,10);
sr_data.hilbert.response.LP8 = NaN(2,64,10);
sr_data.hilbert.response.LP16 = NaN(2,64,10);
sr_data.hilbert.response.LP32 = NaN(2,64,10);
sr_data.hilbert.response.LPinf = NaN(2,64,10);

% set up coherent data
sr_data.coherent.response.LPhalf = NaN(2,64,10);
sr_data.coherent.response.LP1 = NaN(2,64,10);
sr_data.coherent.response.LP2 = NaN(2,64,10);
sr_data.coherent.response.LP4 = NaN(2,64,10);
sr_data.coherent.response.LP8 = NaN(2,64,10);
sr_data.coherent.response.LP16 = NaN(2,64,10);
sr_data.coherent.response.LP32 = NaN(2,64,10);
sr_data.coherent.response.LPinf = NaN(2,64,10);

%% set up date/time info

% set up unprocessed data
sr_data.unprocessed.date = NaN(2,10);

% set up hilbert data
sr_data.hilbert.date.LPhalf = NaN(2,10);
sr_data.hilbert.date.LP1 = NaN(2,10);
sr_data.hilbert.date.LP2 = NaN(2,10);
sr_data.hilbert.date.LP4 = NaN(2,10);
sr_data.hilbert.date.LP8 = NaN(2,10);
sr_data.hilbert.date.LP16 = NaN(2,10);
sr_data.hilbert.date.LP32 = NaN(2,10);
sr_data.hilbert.date.LPinf = NaN(2,10);

% set up coherent data
sr_data.coherent.date.LPhalf = NaN(2,10);
sr_data.coherent.date.LP1 = NaN(2,10);
sr_data.coherent.date.LP2 = NaN(2,10);
sr_data.coherent.date.LP4 = NaN(2,10);
sr_data.coherent.date.LP8 = NaN(2,10);
sr_data.coherent.date.LP16 = NaN(2,10);
sr_data.coherent.date.LP32 = NaN(2,10);
sr_data.coherent.date.LPinf = NaN(2,10);

% Practice data
sr_practice = sr_data;


%% generate random order for study data

% for now we will do unprocessed, hilbert at 1/2 and octave, and coherent.
% we will do 1/2, 2, 8, and 32 Hz LP filters
% order is 
 % 1 = unprocessed
 % 2 = hilbert 1/2 LP
 % 3 = hilbert 1 LP
 % 4 = hilbert 2 LP
 % 5 = hilbert 4 LP
 % 6 = hilbert 8 LP
 % 7 = hilbert 16 LP
 % 8 = hilbert 32 LP
 % 9 = hilbert inf LP

 % 10 = coherent 1/2 LP
 % 11 = coherent 1 LP
 % 12 = coherent 2 LP
 % 13 = coherent 4 LP
 % 14 = coherent 8 LP
 % 15 = coherent 16 LP
 % 16 = coherent 32 LP
 % 17 = coherent inf LP

% we will do two sets. Each set contains each condition. 
% Thus, each condition will be done twice.
sr_data.done = zeros(17,2,10); % 0 = not done, 1 = done; see sr_data.order for explanation
sr_data.order = NaN(17,2,20)
for setID = 1:2
    for subjectID = 1:20
        sr_data.order(:,setID,subjectID) = randperm(17);
    end
end

%% generate random order for practice data

% subject will do two blocks unprocessed and two random blocks of hilbert and
% coherent.
sr_practice.done = zeros(6,1,20);
sr_practice.order = ones(2,1,20);
for subjID = 1:20
    temp = randperm(16); %only 16 conditions
    temp = temp + 1; % get rid of unprocessed by adding one
    temp2 = [find(temp<10) find(temp > 9)] % break out hilbert and coherent data
    temp3 = temp2([1 2 9 10]) % get 1st two of hilbert and coherent
    temp3 = sort(temp3); % sort to original random order
    temp = temp(temp3); % extract hilbert and coherent
    sr_practice.order(3:6,1,subjID) = temp
end

%% save data

answer = questdlg('This will overwrite the order data. Proceed?',...
    'Overwrite data?', 'Yes', 'No','No')
if strcmpi(answer,'yes')
    save sr_data.mat sr_data
    save sr_practice.mat sr_practice
else
    warndlg('new sr data not saved')
end



