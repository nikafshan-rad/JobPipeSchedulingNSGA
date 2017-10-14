function z=Fitness(x,TaskSize,t_f,t_c,p)        
y=x;
     z1=Price(x,TaskSize,p); 
     z2=Makespan(x,TaskSize,t_f,t_c,p);
      
     z=[z1
        z2];
       
end