function z=Compare2array(f,g)

if numel(f)~=numel(g)
    disp('error in sizes of array');
    return;
end
r=[];
for i=1:numel(f)
    if f(i)<=g(i);
        r(i)=1;
    else
        r(i)=0;
    end
end
if sum(r)==numel(f)
    z=1;
else
    z=0;
end

      