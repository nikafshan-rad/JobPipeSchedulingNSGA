function y=schedule(x)
m=x;
j=1;
resource{1}=(1);
n=numel(x);
   for i=1:n
       if m(i)==1
           resource{j}=[resource{j} i+1];
           
       elseif m(i)==0
           j=j+1;
           resource{j}=[];
           resource{j}=[resource{j} i+1];
           
       end
   end
 y=[];
 for h=1:numel(resource)
     for k=1:numel(resource{h})
         y=[y h];
     end
 end
end