function pop=SortPopulation(pop)

    % Sort according to Crowding Distance
    CD=[pop.CrowdingDistance];
    [CD CDSO]=sort(CD,'descend');
    pop=pop(CDSO);
    
    % Sort according to Rank
    R=[pop.Rank];
    [R RSO]=sort(R,'ascend');
    pop=pop(RSO);

end