function [real_fft,real_freqs,tticks]=fft_in_real_dB(w,FS,refdbv,minfreq,maxfreq);

% code for viewing frequency spectrum for any input waveform in real dB
% units; w is the waveform; fs is the sampling rate;
%  optional: refdbv is the voltage to dB reference (if not entered, set to 95);
%  Example: The B&K mic is 131 dB for 1v; TDH headphone is 95dB for 1v
%  This code assumes that the signal is set to the TDT3 standard: 1 = 1v
%  
%  optional:  minfreq and maxfreq set the limits of the fft plot
% Thanks:  real dB code provided by Ginny Richards

if nargin<3  %use these defaults if nothing else is entered
    refdbv=95; minfreq=0; maxfreq=FS/2;
end

%make sure it's a column; if not, flip it
schk=size(w);
if schk(1)<schk(2)
    w=w';
end


%get the rms of the waveform and convert to dB (actual levels)
rmsw = std(w);
rmsdb = 20.*log10(rmsw) + refdbv; 

%calculate the fft for the actual levels
fw = fft(w); 

%convert actual levels to dB
specdb = 20*log10(abs(fw)); 

% convert actual levels to relative units
rspecdb = specdb - max(specdb); 

%convert relative values from dB back to linear units
% use 10log rather than 20log mostly for convenience, but don't forget!
lspec = 10.^(rspecdb./10); 

%add up relative values, using the linear units
s = sum(lspec);  

%get the total of all relative values in dB, using the 10log convention
ts = 10.*log10(s); 

%now that both are in dB, we can figure out what the proper conversion is by 
% calculating the difference between real and relative units in dB
shiftfac = rmsdb - ts;

%now convert all the relative values to real dB values
realdb = rspecdb+shiftfac; 

% use only the positive frequency half, but compensate by adding 3 dB to
% each component (Why? Because dividing linear in half = 3 dB reduction, 
%                      assuming you use the 10log convention)
half = round(length(realdb)/2);
real_fft = realdb(1:half) + (10*log10(2));

% create scale for frequency axis 
dur=length(w)/FS;
fftres=1/dur;
freqs=[0:fftres:FS-fftres]';  
real_freqs=freqs(1:(round(length(freqs)/2)));


maxdB=max(real_fft);
mindB=min(real_fft);
maxamp=max(w);
minamp=min(w);
minmax=max(maxamp,abs(minamp));

mintime=1/FS;
maxtime=(length(w))/FS;
tticks=[mintime:mintime:maxtime]';  %create scale for time in seconds
        

    figure
    subplot(2,1,1)
    plot(real_freqs,real_fft)
    axis([minfreq maxfreq max(0,mindB) max(refdbv,maxdB+5)])
    xlabel('Frequency (Hz)')
    ylabel('Power (dB)')
    
    subplot(2,1,2)
    plot(tticks,w)
    axis([mintime maxtime minmax*-1 minmax])
    xlabel('Time (seconds)')
    ylabel('Amplitude')

