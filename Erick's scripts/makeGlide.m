function s=makeGlide(start_frequency, end_frequency, sampling_rate, duration, amplitude, phase)
% s=makeGlide(start_frequency, end_frequency, sampling_rate, duration, amplitude, phase)
%   makes a linear frequency glide
%   start_frequency: in Hz (e.g., 1000)
%   end_frequency: in Hz (e.g., 1000)
%   sampling_rate: in Hz (e.g., 48000)
%   duration: in seconds (e.g., 1)
%   amplitude: in decibels re: maximum (e.g., -30)
%   phase: starting phase in radians, between 0 and 2*pi (e.g., pi)


s.start_frequency=start_frequency;
s.end_frequency=end_frequency;
s.sampling_rate=sampling_rate;
s.duration=duration;
s.amplitude=amplitude;
s.phase=phase;

%determine the signal length in samples and create a vector (x) of the right length to hold it
x=1:ceil(duration.*sampling_rate);
t=x./sampling_rate;

%generate the frequencies for each sample of the glide

fdiff=(end_frequency-start_frequency).*(t(end).^-1);

%generate a frequency-modulated sine wave
tone = sin(2*pi * (fdiff./2.*(t.^2) + start_frequency.*t));


% create a windowing function (an envelope)
rampdur = 0.02; % 20 millisecond ramps
rampsamps = ceil(rampdur.*sampling_rate);
envelope = [cos(linspace(-pi/2,0,rampsamps)) ones(1,ceil(duration.*sampling_rate)-2*rampsamps) cos(linspace(0,pi/2,rampsamps))].^2;

tone=tone.*envelope;

%set the RMS level of the signal to the specified amplitude in dB relative to 1 volt peak to peak
toneRMS=sqrt(mean(tone.^2));
amp=10^(amplitude/20);
ampdiff=amp/toneRMS;


s.wave=tone.*ampdiff;
