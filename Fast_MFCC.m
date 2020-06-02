function [feat] = Fast_MFCC(samples, fs)
%clear all;
%close all;


%[samples,fs,nbits] = wavread('C:\Users\abualsoud\Dropbox\Spoken Language proc\experiments\sa1_tstDR2mgwt0.wav');

window_size = 20; %20ms
shift = 10; %10ms
nfilts = 44;
 
minfreq = 40;
maxfreq = fs/2;
window_size = floor((window_size/1000)*fs); % convert ms to number of samples
shift = floor((shift/1000)*fs); 
overlap = window_size - shift;

samples = samples - mean(samples);
a = [1,0.97]; % Pre-emphesis Constant
samples = filter(1,a,samples);%Pre-emphesiser 

fba_lmt = exp(-50);
ham=hamming(window_size);

y = buffer(samples,window_size,overlap);

num_frames = size(y,2);
hams =ham*(ones(1,num_frames));
yh = y.*hams;
Eng = sum(yh.^2,1);
NFFT = 2^(ceil(log(window_size)/log(2)));
half = floor(NFFT/2)+1;
fftpower = abs(fft(yh,NFFT)).^2;

fftpower(fftpower<fba_lmt) = fba_lmt;
fftpower = log(fftpower(1:half,:));
triangles = fft2melmx(half, fs, nfilts, 1, minfreq, maxfreq,0,1,0);
fba =triangles*fftpower;
% fba = my_rasta(fba');

%pcolor(fba(:,50:150));
%colormap hot;
%%%%%%%%%%%%%%%%%%%%%%%%%%
e_thr = 1e-4;
energy = sum(yh.^2);
energy(energy <e_thr) = e_thr;
energy = 10*log10(energy);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Zero Crossing Rate
signs = (yh(1:end-1,:).*yh(2:end,:)) < 0 ;
diffs = (yh(1:end-1,:)- yh(2:end,:)) > 0; 
%zcc = sum(signs.*diffs);
zcc = sum(signs);
%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% pitch frequency
 y=samples(:,1);
   auto_corr_y=xcorr(y); 
   %subplot(2,1,1),plot(y) subplot(2,1,2),plot(auto_corr_y) 
   [pks,locs] = findpeaks(auto_corr_y);
   [mm,peak1_ind]=max(pks);
   period=locs(peak1_ind+1)-locs(peak1_ind); 
   pitch_Hz = [fs/period];
   p_threshold =  1e-5;
    pitch_Hz( pitch_Hz <p_threshold) = p_threshold;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
D1 = deltas(fba);
D2 = deltas(D1);
%%%%%% RASTA 

%fba2 = my_rasta(fba);
%figure
%pcolor(fba2(:,50:150));
%colormap hot;

mfcc = dct(fba,14);

%%%% Mean & Variance normalization
mfcc = mfcc;
N = size(mfcc,2);
new_pitch = repmat(pitch_Hz,1,N);
%feat=[mfcc;deltas(mfcc);deltas(deltas(mfcc));energy]';%,deltas(mfcc),deltas(deltas(mfcc))];
feat=[mfcc;deltas(mfcc);deltas(deltas(mfcc));energy]';        %,deltas(mfcc),deltas(deltas(mfcc))];
%feat=[energy;N*ones(1,N);new_pitch]';        %,deltas(mfcc),deltass(deltas(mfcc))];

[nn,dd]= size(feat); %size(feat); %size([m ,delta']);
 feat = (feat - ones(nn,1)*mean(feat))./(ones(nn,1)*std(feat)); 
clear t;
 






