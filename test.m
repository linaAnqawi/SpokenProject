clc
global priorEgy;
  global  transmatEgy;
  global muEgy;
  global SigmaEgy;
  global mixmatEgy ;
    global priorNOR;
  global  transmatNOR;
  global muNOR;
  global SigmaNOR;
  global mixmatNOR ;
  global priorGLF;
  global  transmatGLF;
  global muGLF;
  global SigmaGLF;
  global mixmatGLF ;
   global priorLAV;
  global  transmatLAV;
  global muLAV;
  global SigmaLAV;
  global mixmatLAV ;
    global priorMSA;
  global  transmatMSA;
  global muMSA;
  global SigmaMSA;
  global mixmatMSA ;


%%%%%%%%%%%%%%%%
fileID = fopen('C:\Users\Afnan\Desktop\spokenn\result.txt','w');
fprintf(fileID,'-------------------------------------------------------------- \r\n');

fprintf(fileID,'%6s %17s %20s\r\n','id');

directory = dir('C:\Users\Afnan\Desktop\spokenn\data\test\*.wav')
for j=1:length(directory)
 fname = directory(j).name;
[s,fs] = audioread(['C:\Users\Afnan\Desktop\spokenn\data\test\',fname]);
x = Fast_MFCC(s,fs);
loglikNOR = (mhmm_logprob(x',priorNOR, transmatNOR, muNOR, SigmaNOR, mixmatNOR))
loglikEgy = (mhmm_logprob(x', priorEgy, transmatEgy, muEgy, SigmaEgy, mixmatEgy))
loglikGLF = (mhmm_logprob(x', priorGLF, transmatGLF, muGLF, SigmaGLF, mixmatGLF))
loglikLAV = (mhmm_logprob(x', priorLAV, transmatLAV, muLAV, SigmaLAV, mixmatLAV))
loglikMSA = (mhmm_logprob(x', priorMSA, transmatMSA, muMSA, SigmaMSA, mixmatMSA))



v=[loglikEgy,loglikGLF,loglikLAV,loglikMSA,loglikNOR];

mx=v(1);
for p=2:numel(v)
  if v(p)>mx
   mx=v(p);
  end
end
if mx==loglikEgy
  answer=' EGY';  
  elseif mx==loglikGLF
  answer=' GLF';  
  elseif mx==loglikLAV
  answer=' LAV'; 
  elseif mx==loglikMSA
  answer=' MSA'; 
  
  elseif mx==loglikNOR
  answer=' NOR'; 
end

fprintf('%6s %6d \r\n\r',fname,answer);

    
     
end
 fclose(fileID);
  
 
 
