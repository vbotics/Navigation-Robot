function [img]= vertical(xi,yi,xj,yj,RGB)

flag=0;
    for(i=1:1000)
                
                RGB(yj,xj,1)=240;
                RGB(yj,xj,2)=31;
                RGB(yj,xj,3)=191;
        if(xi==xj)
            if(yi>yj)
                yj=yj+1;
            else if(yi<yj)
                    yj=yj-1;
                else
                    flag=1;
                end
            end
        else
            if(yi==yj)
                if(xi>xj)
                xj=xj+1;
            else if(xi<xj)
                    xj=xj-1;
                else
                    flag=1;
                end
            end
            end
        end
        if flag==1;
            break;
        end
    end
    imshow(RGB)
   [img]=RGB;