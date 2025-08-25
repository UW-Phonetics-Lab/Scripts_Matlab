function n=makeSpectralNoiseBand(low_frequency, high_frequency, sampling_rate, duration, spectral_energy)
% n=makeNoise(low_frequency, high_frequency, sampling_rate, duration, amplitude, bandwidth)
%   low_frequency: in Hz (e.g., 1000)
%   high_frequency: in Hz (e.g., 4000)
%   sampling_rate: in Hz (e.g., 48000)
%   duration: in seconds (e.g., 1)
%   spectral_energy: energy in a 1 Hz component, given in decibels re: maximum (e.g., -30)
% creates a rectangular noise band with a given spectral level per 1 Hz component (E/N0)

n.low_frequency=low_frequency;
n.high_frequency=high_frequency;
n.sampling_rate=sampling_rate;
n.duration=duration;
n.spectral_energy=spectral_energy;


%determine the signal length in samples and create a vector (x) of the right length to hold it
x=1:ceil(duration.*sampling_rate);

% make some noise
% Set the random number generator to a unique state
rand('state',sum(100*clock))
randn('state',sum(100*clock))

% Set the overall generation parameters
totalpts=ceil(duration*sampling_rate);

%CREATE SPECTRUM VECTOR, EQUALIZE and CONVERT TO TIME-DOMAIN
hzppt=1/duration;

flow=round((low_frequency)/hzppt)+1;
fhi=round((high_frequency)/hzppt)+1;
numcomp=(fhi-flow)+1;
realnumcomps=high_frequency-low_frequency+1;

specbuf=zeros(1,totalpts);
specbuf(:,flow:fhi)=randn(1,numcomp)+i*randn(1,numcomp);
expower=(1./totalpts).^2.*numcomp;

sburst=(real(ifft(specbuf))./expower.^0.5);


% create a windowing function (an envelope)
rampdur = 0.005; % 5 millisecond ramps
rampsamps = ceil(rampdur.*sampling_rate);
envelope = [cos(linspace(-pi/2,0,rampsamps)) ones(1,ceil(duration.*sampling_rate)-2*rampsamps) cos(linspace(0,pi/2,rampsamps))].^2;

sburst=sburst.*envelope;

%set the RMS level of the signal to the specified amplitude in dB
noiseRMS=sqrt(mean(sburst.^2));
% calculate the overall RMS amplitude that will give the correct spectral
% energy
amplitude=10*log10(realnumcomps)+spectral_energy;

amp=10^(amplitude/20);
ampdiff=amp/noiseRMS;

n.wave=sburst.*ampdiff;
