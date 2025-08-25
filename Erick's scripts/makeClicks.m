function c=makeClicks(cf,nclicks,clickdur,ici,peak_level,sampling_rate)
% c=makeClicks((cf,clickdur,ici,peak_level,sampling_rate)
%   cf: in Hz (e.g., 1000)
%   nclicks: number of clicks in train
%   clickdur: duration (ms) of each click 
%   ici: interclick interval, peak to peak (ms) (1x1 or 1xN-1)
%   peak_level: level re: 1v Pk (dB)
%   sampling_rate (in Hz)

c.cf=cf;c.nclicks=nclicks;c.clickdur=clickdur;c.ici=ici;c.peak_level=peak_level;c.sampling_rate=sampling_rate;
c.wave=[];

    % get all of the params in 1xN type format
cf = repmat(cf,1,nclicks);
clickdur = repmat(clickdur,1,nclicks);
ici = repmat(ici,1,nclicks-1);
peak_level = repmat(peak_level,1,nclicks);


% convert everything to samples
ms_samprate = sampling_rate ./ 1000; % samp per ms
tick = 1/ms_samprate; % ms per samp
ici_samp = round(ici ./ tick);
clickdur_samp = round(clickdur ./ tick);
cf_samp = cf ./ sampling_rate;  % cycles / sample;


% compute total duration
totalsamps = ceil(clickdur_samp(1)./2) + sum(ici_samp) + floor(clickdur_samp(end)./2); 

c.wave = zeros(1,totalsamps);

for i = 1:nclicks
    
    % compute the click waveform
    click = doclick(cf_samp(i),clickdur_samp(i));

    % compute the abl = 20 log (pk_amp / 1v)
    lev_scale = 10^(peak_level(i)/20);
    click = click .* lev_scale;

    
    if nclicks > 1
        % put it into the train.
        if i == 1
            clickstart(i) = 1;
            clicktime(i) = ceil(length(click)./2);
        else
            clicktime(i) = clicktime(i-1) + ici_samp(i-1);
            clickstart(i) = clicktime(i) - ceil(length(click)./2);
        end

        % add it in, don't overwrite

        c.wave(clickstart(i):clickstart(i)+length(click)-1) = c.wave(clickstart(i):clickstart(i)+length(click)-1) + click;

    else
        c.wave=click;
    end
end



function click = doclick(cf, dur)
%click = doclick(cf, dur)        [cyc/samp samps]
%
% cf = carrier freq (cycles per sample)
% dur = clicklength in samples

sd = dur / 6.66;           % samps per sd. 6.66 sd total dur (full 16 bits)
t = ((1:dur)-(dur/2)); % timebase for computing clicks
click = cos(2* pi* cf * t) .* exp(-(t / sd) .^2);

