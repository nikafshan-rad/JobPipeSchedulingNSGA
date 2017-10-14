% function i=Tournament(pop)
% 
% global nTournament;
% ii=randsample(numel(pop),nTournament);
% CostOrder=[pop(ii).Rank];
% [Cost  sort_order]=sort(CostOrder);
% i=ii(sort_order(1));
% end 
    
function i=Tournament(pop)

    ii=randperm(numel(pop));
    
    i1=ii(1);
    i2=ii(2);
    i3=ii(3);
    
    if pop(i1).Rank<pop(i2).Rank && pop(i1).Rank<pop(i3).Rank
        
        i=i1;
        
    elseif pop(i2).Rank<pop(i1).Rank && pop(i2).Rank<pop(i3).Rank
        
        i=i2;
        
    elseif pop(i3).Rank<pop(i1).Rank && pop(i3).Rank<pop(i2).Rank
        
        i=i3;
        
    else
        if pop(i1).CrowdingDistance>pop(i2).CrowdingDistance
            i=i1;
        else
            i=i2;
        end
 end
    

    
      