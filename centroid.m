function [z cen]=centroid(z,xi,yi,center.center)
cenflag=0;
clear
c(1).cen=[0 0];
m=z;
for (k=1:m)
    if (center(k).center==[xi,yi])
        cenflag=cenflag+1;
    end
end
if (cenflag==0)
    center(k).center=[xi,yi];
    
    z=z+1;
end

                                   