function n=makeSourceSpectrumNoise(spectrum, sampling_rate)
% n=makeSourceSpectrumNoise(sourcespectrum, sampling_rate)
%   spectrum: a frequency-domain vector with amplitudes in volts and
%                   frequency range of 0 to the sampling rate
%   sampling_rate: in Hz (e.g., 44100)
%   duration: in seconds (e.g., 1)
% creates a noise stimulus with the same amplitudes as the input spectrum
% but with random phases.  Duration is the same as the time-domain waveform
% used to create the source spectrum.

n.spectrum=spectrum;
n.sampling_rate=sampling_rate;

rand('state',sum(100*clock))      % Set the random number generator to a unique state
R = abs(spectrum);
theta = angle(spectrum);
theta_rand = (rand(size(R))*2*pi)-pi;     %create a random phase for every component between -pi and pi
Zrand = R.*exp(i*theta_rand);             %create a new complex spectrum with random phases
noise=real(ifft(Zrand));  %CONVERT TO TIME-DOMAIN
duration = length(noise)/sampling_rate;

% create a windowing function (an envelope)with 'rampdur' cosine-squared
% onset and offset ramps
rampdur = 0.005; % 5 millisecond ramps
rampsamps = ceil(rampdur.*sampling_rate);
envelope = [cos(linspace(-pi/2,0,rampsamps)) ones(1,ceil(duration.*sampling_rate)-2*rampsamps) cos(linspace(0,pi/2,rampsamps))].^2;

n.wave=noise.*envelope';

