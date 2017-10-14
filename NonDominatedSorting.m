function [pop F]=NonDominatedSorting(pop)

    nPop=numel(pop);

    F{1}=[];
    
    for i4=1:nPop
        pop(i4).DominatedCount=0;
        pop(i4).DominationSet=[];
        
        for j=[1:i4-1 i4+1:nPop]
            
            if Dominates(pop(i4),pop(j))
                pop(i4).DominationSet=[pop(i4).DominationSet j];
                
            elseif Dominates(pop(j),pop(i4))
                pop(i4).DominatedCount=pop(i4).DominatedCount+1;
                
            end
            
        end
        
        if pop(i4).DominatedCount==0
            F{1}=[F{1} i4];
        end
        
    end
    
    k=1;
    
    while true
        
        Q=[];
        
        for i4=F{k}
            for j=pop(i4).DominationSet
                pop(j).DominatedCount=pop(j).DominatedCount-1;
                
                if pop(j).DominatedCount==0
                    Q=[Q j];
                end
            end
        end
        
        if isempty(Q)
            break;
        end
        
        F{k+1}=Q;
        k=k+1;
        
    end
    
    for k=1:numel(F)
        for i4=F{k}
            pop(i4).Rank=k;
        end
    end
    
end