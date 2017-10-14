function Value=Makespan(x,TaskSize,t_f,t_c,P)

   global R;
   global nResource; %% N

y=x;
W=[];
tf=[];
tc=[];

% if P==0
%     for i=1:nPT
%         W=[W TaskSize{i}];
%         tf=[tf t_f{i}];
%         tc=[tc t_c{i}];
%     end
% elseif P~=0
    W=TaskSize{P};
    tf=t_f{P};
    tc=t_c{P};
% end

CP=R(1,:); %% speed of resources
CB=R(3,:); %% band width between resources and scheduler
TC=zeros(1,nResource);

% EET=zeros(1,nResource);
Ly=numel(y);
for j=1:nResource
   for i=1:Ly
      if y(i)==j
%             
         TC(j)=TC(j)+(W(i)/CP(j))+(tf(i)+tc(i)/CB(j));
      end
   end

 end
%    FitnessValue=max(TC);
   Value=max(TC);
end