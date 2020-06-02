function  y = my_rasta(x,win,sf)

if nargin < 2
  win =[2,1,0,-1,-2];
end

if nargin < 3
  sf = -0.98;
end

if sf > 0
  sf = -1*sf;
end

nd = size(x);
if nd(1) < nd(2)
    x =x';
    trans = 1;
else
    trans = 0;
end

delta = filter(win,1,x);
%delta = deltas (x,3); %delta_coef(x);
y = filter(1,[1,sf],delta);


if trans
    y = y';
end