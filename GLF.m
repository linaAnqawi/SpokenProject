
clc
  global priorGLF;
  global  transmatGLF;
  global muGLF;
  global SigmaGLF;
  global mixmatGLF ;
addpath('C:\Users\Afnan\Desktop\spokenn\data')
directory = dir('C:\Users\Afnan\Desktop\spokenn\data\GLF\*.wav')
data = [];
i=0;


for j=1:30
    filename = directory(j).name;
[s,fs] = audioread(['C:\Users\Afnan\Desktop\spokenn\data\GLF\',filename]);
data = [data,x'];

end

  O = size(data,1);          %Number of coefficients in a vector 
  T = size(data,2);         %Number of vectors in a sequence 
  nex = 1;        %Number of sequences 
  M = 8;          %Number of mixtures 
  Q = 6;          %Number of states 
  cov_type = 'diag';
  % initial guess of parameters
prior0 = normalise(rand(Q,1));
transmat0 = mk_stochastic(rand(Q,Q));

 [mu0, Sigma0] = mixgauss_init(Q*M, data, cov_type);
  mu0 = reshape(mu0, [O Q M]);
  Sigma0 = reshape(Sigma0, [O O Q M]);
  mixmat0 = mk_stochastic(rand(Q,M));
  
  [LL, priorGLF, transmatGLF, muGLF, SigmaGLF, mixmatGLF] = ...
    mhmm_em(data, prior0, transmat0, mu0, Sigma0, mixmat0, 'max_iter', 10);

word.prior = priorGLF;
word. trans = transmatGLF;
word.mu = muGLF;
word.sig = SigmaGLF;
word.mix = mixmatGLF;
save('GLF.mat', 'word');


loglikGLF = mhmm_logprob(data, priorGLF, transmatGLF, muGLF, SigmaGLF, mixmatGLF)






