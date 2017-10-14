function y=Mutate(x,mem_requir,p)

    global nResource;
    global PTnTask;
    
    nVar=numel(x);
    mu=rand(1);        
    m=ceil(mu*nVar);
    
    jj=randsample(nVar,m);
    
    y=x; 
 
%     for i=1:numel(jj)
%        if x(jj(i))==1 && sum(y)>PTnTask(p)-nResource 
%            y(jj(i))=0;
%        elseif x(jj(i))==0 
%            y(jj(i))=1;
%        end          
%     end
       for i=2:nVar
           z=y;
           if x(i)==1 && sum(y)>PTnTask(p)-nResource
               z(i)=0;
               if CheckMemUsage(z,mem_requir,p)
                   y=z;
%                    break;
               end
           end
           if x(i)==0
               z(i)=1;
               if CheckMemUsage(z,mem_requir,p)
                   y=z;
%                    break;
               end
           end
       end
end
