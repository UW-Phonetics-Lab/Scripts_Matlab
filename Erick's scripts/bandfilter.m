function [out]=bandfilter(in,order)
maxchan = 13;

if nargin<2
order = 1;
end
rate = 44100;

cf=[187.5 250 375 500 750 1000 1500 2000 3000 4000 6000 8000 12000];
% create a windowing function (an envelope)
rampdur = 0.005; % 5 millisecond ramps
rampsamps = ceil(rampdur.*rate);
envelope = [cos(linspace(-pi/2,0,rampsamps)) ones(1,ceil(length(in))-2*rampsamps) cos(linspace(0,pi/2,rampsamps))].^2;



for i = 2:maxchan-1
  %rate/2 scales cutoff for input into butter command such that 0.0<cutoff<1.0,
  %where 1.0 = rate/2
  lfcut(i) = (cf(i-1)/(rate/2));	
  hfcut(i) = (cf(i+1)/(rate/2));
end   

%lowpass filter below 187.5
        % bandpass filtering design
        [B2, A2] = butter(order, cf(1)/(rate/2));        
        % lowpass filtering
        out(:,1) = filtfilt(B2, A2, in);
          out(:,1) = out(:,1).*envelope';
for ch = 2:maxchan-1
     
        % bandpass filtering design
        [B2, A2] = butter(order, [lfcut(ch) hfcut(ch)]); 
        
        % bandpass filtering
        
        out(:,ch) = filtfilt(B2, A2, in);
         out(:,ch) = out(:,ch).*envelope';
end