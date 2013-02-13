function cm_full_lbls = cm_predict(W, labels, training_set_indicator, c)
%%%
% CM alg by scholkopf et.al. 2003
%%%
alpha = 1/(1+c); % scholkopf et.al. 2003 Eq. (3.7)
s = sum(W);
min_s = min(s(s>0));
s(s==0) = min_s(1)/10; % to prevent division by zero 
D_pow_half = sqrt( diag( 1./s ) ); % note that W is symmetric & inv of diag matt is 1/M_ii
S = D_pow_half * W * D_pow_half;
labels( training_set_indicator==0 ) = 0;
cm_full_lbls = inv(eye(length(labels))-alpha*S)*labels;