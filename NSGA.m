clc;
clear;
close all;

%% problem definition

global PTnTask;
global R;
global nPT; 
global MaxSize;
global nTournament;
global nPop;
global nResource;
% global t_f;
% global t_c;

nPT=3; %% number of paths %% WARNING: after changing this item please change other correlate items
%%please change Lines 19,190,191,192
PTnTask=[60 50 40];    %% number of Tasks for every path %% WARNING: Lines 17,190,191,192
nResource=20;  %% number of Resources
MinSize=20;   %% minimum size of tasks
MaxSize=100;  %% maximum size of tasks
MinSpeedOfResource=2;     %% min speed of resources
MaxSpeedOfResource=10;    %% max speed of resources
MinBandWidth=20;   %% (bps) min of band width between node and scheduler
MaxBandWidth=100;  %% (bps) max of band width between node and scheduler
MinMemory=200;    %% min of availabe memory on resources (M)
MaxMemory=1000;    %% max of availabe memory on resources (M)

R1=(MaxSpeedOfResource-MinSpeedOfResource).*rand(1,nResource)+MinSpeedOfResource;   %%speed of cpu
% R1=sort(R1);
R2=(MaxSize-MinSize).*rand(1,nResource)+MinSize;               %% initial tasks on resources
R3=(MaxBandWidth-MinBandWidth).*rand(1,nResource)+MinBandWidth;
R4=(MaxMemory-MinMemory).*rand(1,nResource)+MinMemory;
R=[R1
   R2
   R3
   R4];

%% GA parameters
MaxIt=50;
nPop=100;
nTournament=2;

pCrossover=0.8;
nCrossover=round(pCrossover*nPop/2)*2;

pMutation=0.1;
nMutation=round(pMutation*nPop);

%% Initialization  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
individual.Position={};
individual.Cost=[];
individual.Rank=[];
individual.CrowdingDistance=[];
individual.DominatedCount=[];
individual.DominationSet=[];

pop=repmat(individual,nPop,1);
% TaskSize=round(unifrnd(1,MaxCSs,[1 nAbService]));
 
for PT=1:nPT
  %% generate size of both tasks and transfering files for path number pp
TaskSize{PT}=unifrnd(MinSize,MaxSize,[1 PTnTask(PT)]);  %% size of job workload (billion instructions)
t_f{PT}=TaskSize{PT}+ 0.01*TaskSize{PT};  %% size(bit) of file for task i that is transfered to the node from the scheduler
t_c{PT}=TaskSize{PT}+ 0.02*TaskSize{PT};  %% size(bit) of file for task i that is transfered to the scheduler from the node
mem_requir{PT}=TaskSize{PT}+0.5*TaskSize{PT};  %% task memory requirement

  %% generate initial population for every path
%     z=ceil((nResource-1).*rand(1))+1;
%     jj=randsample(nResource,z);
%         k=1;
% for i=1:nPop*200
% %          pop2(i).Position=Initialization(mem_requir,PT);
%        pop1=ones(1,PTnTask(PT)-1);%%(i).Position
%        z=ceil((nResource-1).*rand(1));
%        jj=randsample(PTnTask(PT)-1,z);
%        pop1(jj)=0;%%(i).Position
%        S=CheckMemUsage(pop1,mem_requir,PT); %% verifying or modifying individuals in terms of Memory Usage
% %        
%        if S
%            pop(k).Position=pop1;
%            pop(k).Cost=Fitness(pop1,TaskSize,t_f,t_c,PT);
%            k=k+1;
%        end
%     
% end
if PT==1
load('matlab.mat');
pop1=pop(1:nPop);
end
if PT==2
load('matlab1.mat');
pop1=pop(1:nPop);
end
if PT==3
load('matlab2.mat');
pop1=pop(1:nPop);
end

BestCost=zeros(1,MaxIt);
meanCost=zeros(1,MaxIt);
   
   % Non-dominated Sorting
   [pop1 F]=NonDominatedSorting(pop1);

   % Calculate Crowding Distances
   pop1=CalcCrowdingDistance(pop1,F);
   
%%GA main loop
for it=1:MaxIt
    
    %%crossover  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    pop2=repmat(individual,nCrossover/2,2);
for k=1:nCrossover/2
     
    L1=PTnTask(PT)-nResource-1;
    L2=L1;
    while L1<PTnTask(PT)-nResource || L2<PTnTask(PT)-nResource 
       i1=Tournament(pop1);%ceil((nPop-1).*rand(1))+1;
       i2=Tournament(pop1);%ceil((nPop-1).*rand(1))+1;
       
       p1=pop1(i1).Position;
       p2=pop1(i2).Position;
      
       [a, b]=Crossover(p1,p2,mem_requir,PT);
       L1=sum(a);
       L2=sum(b);
    end
    
       ch1.Position=a;
       ch2.Position=b; 
%        ch1.Position=CheckMemoryUsage(a,mem_requir,PT); %% verifying or modifying individuals in terms of Memory Usage
%        ch2.Position=CheckMemoryUsage(b,mem_requir,PT); %% verifying or modifying individuals in terms of Memory Usage
       ch1.Cost=Fitness(ch1.Position,TaskSize,t_f,t_c,PT);
       ch2.Cost=Fitness(ch2.Position,TaskSize,t_f,t_c,PT);
      
       pop2(k,1).Position=ch1.Position;
       pop2(k,2).Position=ch2.Position;
       pop2(k,1).Cost=ch1.Cost;
       pop2(k,2).Cost=ch2.Cost;     
end
       pop2=pop2(:);
    
     %%  mutation  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       mu=pMutation;
       nMutation=ceil(pMutation*numel(pop1));
       pop3=repmat(individual,nMutation,1);
   for k=1:nMutation
        
        i3=Tournament(pop1);%ceil((nPop-1)*rand(1)+1);
        
        q=Mutate(pop1(i3).Position,mem_requir,PT);
        p.Position=q;
        p.Cost=Fitness(q,TaskSize,t_f,t_c,PT);
              
        pop3(k).Position=p.Position;
        pop3(k).Cost=p.Cost;
       
   end

    %% merg population  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      pop4=[pop1  
            pop2
            pop3];
    %%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    % Non-dominated Sorting
    [pop4, F]=NonDominatedSorting(pop4);
    
    % Calculate Crowding Distances
    pop4=CalcCrowdingDistance(pop4,F);
    
    % Sort Population
    pop4=SortPopulation(pop4);
 
    % Delete Extra Individuals
    pop4=pop4(1:nPop);
    
    % Non-dominated Sorting
    [pop4, F]=NonDominatedSorting(pop4);
    
    % Calculate Crowding Distances
    pop4=CalcCrowdingDistance(pop4,F);
        
     %% store result  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    pop1=pop4;  
    
     % Plot F1  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      PF=pop1(F{1});
      PFCosts=[PF.Cost];
%       figure(1);
%       plot3(PFCosts(1,:),PFCosts(2,:),PFCosts(3,:),'*');
%       xlabel('f_1:price');
%       ylabel('f_2:Makespan');
%       grid on;
      
      % Calculate f1 , f2 , f3 from F set  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for ii=1:numel(PF)
        BB=PF(ii).Position;
        u2(ii)=Price(BB,TaskSize,PT);
        Mspn(ii)=Makespan(BB,TaskSize,t_f,t_c,PT);
    end
       
    BestPrice(it)=min(u2);
       
    BestMakespan(it)=min(Mspn);
    MeanMakespan(it)=mean(Mspn);
      
    % Make Trading off between f1 , f2 and f3 Objectives  %%%%%%%%%%%%%%%%%       
      for t=1:numel(PF)
         sumPF(t)=(PFCosts(1,t)+PFCosts(2,t))/2;
      end
      
      [minPF(it) Index]=min(sumPF);
      meanPF(it)=mean(sumPF);
   % Display Best and Mean Solutions From F set  %%%%%%%%%%%%%%%%%%%%%%%%%%
     disp(['Iteraion ' num2str(it) ': Number of F1 Members = ' num2str(numel(PF))]);     
     disp(['Best Fitness=' num2str(minPF(it))]);
     disp(['Mean Fitness=' num2str(meanPF(it))]);
     

     
end
     figure(5);
      plot(PFCosts(1,:),PFCosts(2,:),'go','MarkerFaceColor','g');
      xlabel('f_1:Price');
      ylabel('f_2:Makespan');
      grid('on');
      hold on;
%% Display Results
g=schedule(pop1(1).Position);
disp(['path ' num2str(PT)]);
disp(['Best chromosome for path ' num2str(PT),' =' num2str(pop1(1).Position)]);
disp(['Best shedule for path ' num2str(PT),' =' num2str(g)]);
% disp(['Best Fitness for path ' num2str(PT),' =' num2str(pop1(1).Cost)]);

figure(PT);
plot(BestCost,'g-');
hold on
plot(meanCost,'b-');
legend('Best Fitness','Mean Fitness');
title(['Fitness of path ' num2str(PT), ' with ' num2str(PTnTask(PT)),' Tasks']);
xlabel('Iteration');
ylabel('Fitness');

%% choose 4 best solutions for every path in pipeline
bestsol{PT}={pop1(1) pop1(2) pop1(3) pop1(4)};      
end
Greedy={};
for t=1:nPT 
    for k=1:4
        Greedy{k,t}.Position=[bestsol{t}{k}.Position];  
        Greedy{k,t}.Cost=bestsol{t}{k}.Cost;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%
% q=1;e=0;
% [l1 l2]=size(Greedy);
% Comb=repmat(individual,l1^l2,1);
% for ii=1:4
%     for j=1:4
%         for k=1:4      
%             for h=1:l2 %% l2=nPT
%               Comb{q}.Position=[Comb{q}.Position Greedy{ii,h}];
%             end
% 
%               q=q+1;
%         end
%     end
% end
%%%%%%%%%%%%%%%%%%%%%%%%
Comb=repmat(individual,4^nPT,1);
l=1;e=0;
for i=1:4
    for j=1:4
        for k=1:4      
             Comb(l).Position=[Greedy{i,1}.Position Greedy{j,2}.Position Greedy{k,3}.Position];   %% Combination
             Comb(l).Schedule=[schedule(Greedy{i,1}.Position) schedule(Greedy{j,2}.Position) schedule(Greedy{k,3}.Position)];
             Comb(l).Cost=Greedy{i,1}.Cost+Greedy{j,2}.Cost+Greedy{k,3}.Cost;
%              Comb{l}=[Greedy{i,1} Greedy{j,2} Greedy{k,3}];
             l=l+1;
        end
    end
end

Cost=[Comb.Cost];
[Cost , Sort_Order]=sort(Cost,'descend');   %% ascending order
Comb=Comb(Sort_Order);
disp(['Best Chrom for all paths in pipeline GA = ' num2str(Comb(1).Position)]);
disp(['Best shedule for all paths in pipeline = ' num2str(Comb(1).Schedule)]);
% disp(['Best Fitness for all paths in pipeline = ' num2str(Comb(1).Cost)]);  
% BestPF=PF(Index,1);
% BestPF.Position   
 
%Results  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



figure(6);
subplot(2,2,1)
plot(minPF,'g-','Linewidth',1);
hold on;
plot(meanPF,'b:','LineWidth',1);
legend('Best Costs','Mean Costs');
title('Load Balancing Strategy With GA');
xlabel('Iteration');
ylabel('Fitness');

subplot(2,2,3)
plot(BestMakespan,'g-','Linewidth',1);
hold on
plot(MeanMakespan,'-','LineWidth',1);
legend('Best Makespan','Mean Makespan');
title('Makespan');
xlabel('Iteration');
ylabel('Makespan');

subplot(2,2,2)
plot(BestPrice,'r-','lineWidth',1);
title('Execution Cost Of Scheduling');
xlabel('Iteration');
ylabel('Price');

