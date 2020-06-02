clc
addpath('C:\Users\Sana\Desktop\HMM-20181218T134450Z-001\HMM');
directory = dir('rojomallshyateen\*.wav');
data = [];
i=0;


for j=1:7
    filename = directory(j).name;
[s,fs] = audioread(['rojomallshyateen\',filename]);
x = Fast_MFCC(s,fs);
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
  
  [LL, prior1, transmat1, mu1, Sigma1, mixmat1] = ...
    mhmm_em(data, prior0, transmat0, mu0, Sigma0, mixmat0, 'max_iter', 10);

word.prior = prior1;
word. trans = transmat1;
word.mu = mu1;
word.sig = Sigma1;
word.mix = mixmat1;
save('lyab.mat', 'word');


loglik = mhmm_logprob(data, prior1, transmat1, mu1, Sigma1, mixmat1)


