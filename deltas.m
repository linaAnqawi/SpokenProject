function d = deltas(x, w)
% D = deltas(X,W)  Calculate the deltas (derivatives) of a sequence
%    Use a W-point window (W odd, default 5) to calculate deltas using a
%    simple linear slope. Each row of X is filtered separately.

if nargin < 2
  w = 5;
end

[nr,nc] = size(x);

% Define window shape
hlen = floor(w/2);
w = 2*hlen + 1;
win = hlen:-1:-hlen;


% pad data by repeating first and last columns
xx = [repmat(x(:,1),1,hlen),x,repmat(x(:,end),1,hlen)];

% Apply the delta filter
d = filter(win, 1, xx, [], 2);  % filter along dim 2 (rows)

% Trim edges
d = d(:,2*hlen + [1:nc]);
