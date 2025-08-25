function spectro(signal,analysis_time,sampling_rate)
%spectro(signal,analysis_time,sampling_rate)
% signal: signal to be analyzed
% analysis_time: window length in milliseconds
% sampling_rate: sampling rate in Hz
figure

at=ceil(((analysis_time*1000)./sampling_rate)*1000);
spectrogram(signal,at,0,at,sampling_rate,'yaxis');