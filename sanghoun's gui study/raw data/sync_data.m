function sync_data
% used to sync the raw data to the analysis folder

% created 2010.01.25 by marc brennan

% make sure user wants to do this
answer = questdlg('This will overwrite .mat files in raw data copy. A backup will be made. Continue?',...
    'Overwrite?','Yes','No','No');
if strcmpi(answer,'No')
    warndlg('Data not copied');
    return
end

% determine location of raw data and raw data copy
raw_data_location = cd;
if ~strcmpi(raw_data_location(end-7:end),'Raw Data')
    warndlg('please switch current directory to raw data location')
    return
end

analysis_raw_data_location = ...
    [raw_data_location(1:end-8) filesep 'Analysis' filesep 'Raw Data Copy'];

% specify current date
current_date = clock;
current_date = current_date(1:3);
current_date = [num2str(current_date(1)) '_' ...
    num2str(current_date(2)) '_' ...
    num2str(current_date(3))];

% create backup folder
mkdir(fullfile(analysis_raw_data_location,'backups',current_date));

% backup analysis raw data
file_names = dir([analysis_raw_data_location filesep '*.mat']);
for i = 1:length(file_names)
    copyfile(fullfile(analysis_raw_data_location,file_names(i).name),...
        fullfile(analysis_raw_data_location,'backups',current_date,...
        file_names(i).name))
end

% copy raw data to raw data copy
file_names = dir([raw_data_location filesep '*.mat']);
for i = 1:length(file_names)
    copyfile(fullfile(raw_data_location, file_names(i).name),...
        fullfile(analysis_raw_data_location, file_names(i).name))
end

msgbox('Data copied');
