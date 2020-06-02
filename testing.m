clc
%%%%%%%%%%%%%%%%
addpath('C:\Users\Sana\Desktop\HMM-20181218T134450Z-001\HMM');
fileID = fopen('HMM_Results_rojoo.txt','w');
fprintf(fileID,'HMM-threshold =  -3.5000e+03 \r\n');
fprintf(fileID,'-------------------------------------------------------------- \r\n');

fprintf(fileID,'%6s %17s %20s\r\n','id','Score','Status');

directory = dir('rojomallshyateen\*.wav');
for j=30:length(directory)
 fname = directory(j).name;
[s,fs] = audioread(['rojomallshyateen\',fname]);
x = Fast_MFCC(s,fs);

loglik = (mhmm_logprob(x', prior1, transmat1, mu1, Sigma1, mixmat1));
 
 %save result1.txt prior1 -ascii;
 threshold = -2.9500e+04;
 fprintf('Score is:%d ', loglik);

 if (loglik > threshold)
     
      status ='accepted';
     
     
     
 else
     status ='rejected';
 end
     
fprintf(fileID,'%6s %18f %24s\r\n\r\n ',fname,loglik, status);
    
     
end
 fclose(fileID);
  
 
 



