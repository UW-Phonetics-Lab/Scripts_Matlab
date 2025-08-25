function am=makeAMTone(frequency, modulation_frequency, sampling_rate, duration, amplitude, AM_depth, carrier_phase, AM_phase)
% am=makeAMTone(frequency, modulation_frequency, sampling_rate, duration, amplitude, AM_depth, carrier_phase, AM_phase)
%   frequency: in Hz (e.g., 1000)
%   modulation_frequency: in Hz (e.g., 75)
%   sampling_rate: in Hz (e.g., 48000)
%   duration: in seconds (e.g., 1)
%   amplitude: in decibels re: maximum (e.g., -30)
%   AM_depth: modulation depth in percentage, from 0 to 100
%   carrier_phase: carrier phase, in radians, between 0 and 2*pi (e.g., pi)
%   AM_phase: modulation phase, in radians, between 0 and 2*pi (e.g., pi)


am.frequency=frequency;
am.modulation_frequency=modulation_frequency;
am.sampling_rate=sampling_rate;
am.duration=duration;
am.amplitude=amplitude;
am.carrier_phase=carrier_phase;
am.AM_depth=AM_depth;
am.AM_phase=AM_phase;

%determine the signal length in samples and create a vector (x) of the right length to hold it
x=1:ceil(duration.*sampling_rate);

%generate a sine wave
tone=sin((2*pi*(frequency/sampling_rate).*x)+carrier_phase);

%generate a modulation wave

modulator=(AM_depth./100).*sin((2*pi*(modulation_frequency/sampling_rate).*x)+AM_phase);
modulator=(modulator.*.5)+.5;

%modulate the carrier
AMtone=tone.*modulator;

% create a windowing function (an envelope)
rampdur = 0.02; % 20 millisecond ramps
rampsamps = ceil(rampdur.*sampling_rate);
envelope = [cos(linspace(-pi/2,0,rampsamps)) ones(1,ceil(duration.*sampling_rate)-2*rampsamps) cos(linspace(0,pi/2,rampsamps))].^2;

AMtone=AMtone.*envelope;

%set the RMS level of the signal to the specified amplitude in dB
AMtoneRMS=sqrt(mean(AMtone.^2));
amp=10^(amplitude/20);
ampdiff=amp/AMtoneRMS;


am.wave=AMtone.*ampdiff;
