function s=makeTone2(frequency, sampling_rate, duration, amplitude, phase, onoff_ramp)
% s=makeTone(frequency, sampling_rate, duration, amplitude, phase)
%   frequency: in Hz (e.g., 1000)
%   sampling_rate: in Hz (e.g., 48000)
%   duration: in seconds (e.g., 1)
%   amplitude: in decibels re: maximum (e.g., -30)
%   phase: in radians, between 0 and 2*pi (e.g., pi)
%   onofframp: in seconds (e.g., .01)

s.frequency=frequency;
s.sampling_rate=sampling_rate;
s.duration=duration;
s.amplitude=amplitude;
s.phase=phase;

%determine the signal length in samples and create a vector (x) of the right length to hold it
x=1:ceil(duration.*sampling_rate);

%generate a sine wave
tone=sin((2*pi*(frequency/sampling_rate).*x)+phase);

% create a windowing function (an envelope)
rampdur = onoff_ramp;
rampsamps = ceil(rampdur.*sampling_rate);
envelope = [cos(linspace(-pi/2,0,rampsamps)) ones(1,ceil(duration.*sampling_rate)-2*rampsamps) cos(linspace(0,pi/2,rampsamps))].^2;

tone=tone.*envelope;

%set the RMS level of the signal to the specified amplitude in dB
toneRMS=sqrt(mean(tone.^2));
amp=10^(amplitude/20);
ampdiff=amp/toneRMS;


s.wave=tone.*ampdiff;
