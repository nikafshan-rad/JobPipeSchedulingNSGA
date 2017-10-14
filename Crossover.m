function [ch1, ch2]=Crossover(p1,p2,mem_requir,p)

   x1=p1;
   x2=p2;
   ch1=p1;
   ch2=p2;
   nx1=0;
   nx2=0;
for i=2:numel(x1)-1
    if x1(i)==0
        nx1=nx1+1;
    end
    if x2(i)==0
        nx2=nx2+1;
    end
    if nx1==nx2
        y1=[x1(1:i) x2(i+1:end)];
        y2=[x2(1:i) x1(i+1:end)];
        if CheckMemUsage(y1,mem_requir,p)
            disp('ok');
            ch1=y1;
%             break;
        end
        if CheckMemUsage(y2,mem_requir,p)
            disp('ok');
            ch2=y2;
%             break;
        end
    end
end
end