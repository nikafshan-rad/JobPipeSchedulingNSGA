function S=CheckMemUsage(x,mem_requir,p)

global R;
global nResource;

y=schedule(x);
n=numel(x);
W=[];
RM=[];
TM=[];


ResM=R(4,:);
TaskM=mem_requir{p};
TR=zeros(1,nResource);  %% Tasks usage memory on each resource

Ly=numel(y);
    for j=1:nResource
      for i=1:Ly
         if y(i)==j
             TR(j)=TR(j)+TaskM(i);
         end
      end
    end
    S=Compare2array(TR,ResM);%% return 1 if TR<=ResM and 0 otherwise