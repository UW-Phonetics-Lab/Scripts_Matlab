clear all;

home=pwd;   % this is the directory where this file is located and where the outputs will be stored
sourcedir='/Users/grant/Desktop/NIH Souza Wright/recordings/DIALECT3 STIMS (symmetrical study)/postRMS wav files';  %change this to the directory with the source files
zerolength=215000;
sourcesum=zeros(zerolength,1);     % this is a vector of zeros longer than the longest of the source files
D=dir([sourcedir '/*.wav'])
for n=1:length(D)
    
    target=D(n).name
    [x,sampling_rate,nbits]=wavread([sourcedir '/' target]);
    padlen=zerolength-length(x);
    if padlen < 0
        target
        disp(['Summing vector is too short.  Increase by ' num2str(padlen*-1) ' points.'])
        return  % oops, your vector is too short
    end
    padzeros=zeros(padlen,1);    
    xpad=[x; padzeros];
    sourcesum=sourcesum+xpad;
end

spectrum=fft(sourcesum);
n=makeSourceSpectrumNoise(spectrum, sampling_rate);

[source_fft,real_freqs,tticks]=fft_in_real_dB(sourcesum,44100,95,0,10000);
[noise_fft,real_freqs,tticks]=fft_in_real_dB(n.wave,44100,95,0,10000);
save summed_source_spectra sourcesum source_fft noise_fft real_freqs tticks n

% assuming all files are already RMS normalized, just get the RMS ampl. of
% the first one in the list
tempwav = wavread([sourcedir '/' D(1).name]);
targetRMS = sqrt(sum(tempwav(:).^2)/length(tempwav(:)));
noiseLevel = std(n.wave);
normalizedNoise = n.wave .* (targetRMS/noiseLevel);
wavwrite(normalizedNoise, n.sampling_rate, 'normalizedSpeechSpectrumNoise.wav');

figure
subplot(2,2,1)
plot(tticks,sourcesum)
axis([0 2 -5 5])
grid on
xlabel('Time (seconds)')
ylabel('Amplitude (volts)')

subplot(2,2,2)
semilogx(real_freqs,source_fft)
axis([50 16000 0 75])
grid on
ylabel('Power (dB)')
xlabel('Frequency (Hz)')
set(gca,'XTick',[50 100 200 400 800 1600 3200 6400 12800])

subplot(2,2,3)
plot(tticks,n.wave)
axis([0 2 -5 5])
grid on
xlabel('Time (seconds)')
ylabel('Amplitude (volts)')

subplot(2,2,4)
semilogx(real_freqs,noise_fft)
axis([50 16000 0 75])
grid on
ylabel('Power (dB)')
xlabel('Frequency (Hz)')
set(gca,'XTick',[50 100 200 400 800 1600 3200 6400 12800])