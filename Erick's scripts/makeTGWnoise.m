clear all;
home=pwd;
sourcedir='/Users/grant/Desktop/NIH Souza Wright/recordings/DIALECT2 STIMS (symmetrical study)/postRMS wav files';
zerolength=150000;
sourcesum=zeros(zerolength,1);     % this is a vector of zeros longer than the longest of the source files
D=dir([sourcedir '\*.wav']);
for n=1:length(D)
    target=D(n).name
    [x,sampling_rate,nbits]=wavread([sourcedir '\' target]);
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


sumvals=sourcesum(1:1e5);
plot(sumvals)

[source noise30]=createStimNoise(sumvals,44100,30,0,1);

%calfile='\\vha20nasr\POR Migration\COS-NCRAR Restricted Files\Konrad-Martin\Cal Tones\raw_calibration_tone.wav';

%cal_RMS=std(caltone(50000:1000000,1)); %use just the left channel,and leave out the silence
%scalefac=cal_RMS./std(noise30.wave);
scalefac=0.1 ./std(noise30.wave);
noise30_scaled=noise30.wave.*scalefac;
wavwrite(noise30_scaled,44100,32,[sourcedir '\noise_float_30000ms.wav'])
save noisedata noise30 noise30_scaled cal_RMS source