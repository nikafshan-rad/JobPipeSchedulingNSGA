function parents = selectionroulette(expectation,nParents,options)

expectation = expectation(:,1);
wheel = cumsum(expectation) / nParents;

parents = zeros(1,nParents);
for i = 1:nParents
    r = rand;
    for j = 1:length(wheel)
        if(r < wheel(j))
            parents(i) = j;
            break;
        end
    end
end
    
