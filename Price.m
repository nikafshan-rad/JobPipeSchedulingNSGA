function e=Price(x,TaskSize,p)

global R;

y=schedule(x);
r=R;
e=0;
n=TaskSize{p};
Ly=numel(y);

  for i=1:Ly  
     e=e+((n(i)*r(2,y(i))));
  end
end