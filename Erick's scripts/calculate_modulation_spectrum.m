% code for extracting modulation spectrum for any input waveform
%   works for signals of arbitrary duration
%
%   Written by:  Frederick J. Gallun, PhD,
%                VA RR&D National Center for Rehabilitative Auditory Research
%                February, 2007; Modified October, 2009


length=5;  % minimum length of analysis window in seconds

% first, read in file
[FileName,PathName] = uigetfile('*.wav','Select the wavefile');
[x,fs]=wavread([PathName FileName]);

xlen=max(size(x));
minlen=fs*length; 
padlen=xlen-minlen;

if padlen < 0   
xx=[x' zeros(1,-padlen)]';    % pad input file with zeros to create five second long file 
                          % zeropadding gives better frequency resolution in fft                
else
    xx=x(1:minlen);  %if signal is longer than five seconds, analyze only the first five seconds.
end
%envelope extraction 
lpcut = 50;
order = 4;

% half-wave rectification
it = find(xx < 0);
xx(it) = 0;


% low-pass filering
[B3, A3] = butter(4, lpcut/(fs/2));
lpx = filter (B3, A3, xx);

% fourier transfrom
xfft=fft(lpx);
dc=abs(xfft(1));
xfft_neg=abs(xfft((minlen/2)+1:end));
xfft_pos=abs(xfft(2:(minlen/2)+1));
sum_xfft=[dc; xfft_pos+flipud(xfft_neg)];  %sum positive and negative values to get full amplitude 



modindex_fft=sum_xfft./dc;  %transform complex fft into amplitude, expressed as value relative to dc

fftdB=20*log10(sum_xfft./dc);  %transform complex fft into amplitude, expressed as dB relative to dc
xticks=[0:.2:(fs/2)]';  % create scale for frequency axis    
                        % each point in fft has resolution of .2 Hz due to length of zeropadded input file
                        % for this reason, the values in 'xticks' increases by .2 Hz per step                                  
figure
subplot(1,2,1)
% in the left plot is the modulation spectrum for 0-100 Hz
plot(xticks,fftdB)
axis([0 40 -50 0])
xlabel('Modulation Frequency (Hz)')
ylabel('Magnitude relative to dc (dB)')

subplot(1,2,2)
% in the right plot are the modulation index values for 0-10 Hz
plot(xticks,modindex_fft)
axis([0 40 0 1])
xlabel('Modulation Frequency (Hz)')
ylabel('Magnitude relative to dc (modulation index)')

% output is a list of all of the magnitude values for each frequency
% between 0 Hz (DC) and 'maxfreq'.
maxfreq=100;  % change this value to get a wider range of values
disp(' ')
disp('Frequency  Magnitude(dB)  Modulation Index')
dBvals=[xticks(1:5:maxfreq*5+1),fftdB(1:5:maxfreq*5+1),modindex_fft(1:5:maxfreq*5+1)];
disp(dBvals)
