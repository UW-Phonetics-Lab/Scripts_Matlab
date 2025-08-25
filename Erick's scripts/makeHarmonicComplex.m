function [s t]=makeHarmonicComplex(fundamental, numcomps, sampling_rate, duration, amplitude, relative_amp, phase, onoff_ramp)
% [s t]=makeHarmonicComplex(fundamental, numcomps, sampling_rate, duration, amplitude, relative_amps, phase, onoff_ramp)
%   fundamental: frequency in Hz (e.g., 1000)
%   numcomps: number of harmonic components (e.g., 4)
%   sampling_rate: in Hz (e.g., 48000)
%   duration: in seconds (e.g., 1)
%   amplitude: in decibels re: maximum (e.g., -30)
%   relative_amp:  dB change per component (e.g., -6)
%   phase: in radians, between 0 and 2*pi (e.g., pi)
%   onofframp: in seconds (e.g., .01)

svals=fundamental*[1:numcomps];
slevs=[amplitude + (relative_amp*[0:numcomps-1])];
s=zeros(1,(sampling_rate*duration));

for n=1:numcomps
t{n}=makeTone2(svals(n), sampling_rate, duration, slevs(n), phase, onoff_ramp)';
s=s+t{n}.wave;
end

% minfreq=20;
% maxfreq=max(svals)+1000;
% refdbv=80;
% 
% [complex_fft,cfreqs,tticks]=fft_in_real_dB(s,44100,refdbv,minfreq,maxfreq);
% [tone_fft,sfreqs,tticks]=fft_in_real_dB(t{1}.wave,44100,refdbv,minfreq,maxfreq);
% 
% maxdB=max(complex_fft);
% mindB=min(complex_fft);
% 
%     figure
%     subplot(1,2,2)
%     plot(cfreqs,complex_fft,'k','LineWidth',2)
%     axis([minfreq maxfreq max(0,mindB) max(refdbv,maxdB+5)])
%     xlabel('Frequency (Hz)')
%     ylabel('Power (dB)')
%     
%     subplot(1,2,1)
%     plot(sfreqs,tone_fft,'k','LineWidth',2)
%     axis([minfreq maxfreq max(0,mindB) max(refdbv,maxdB+5)])
%     xlabel('Frequency (Hz)')
%     ylabel('Power (dB)')