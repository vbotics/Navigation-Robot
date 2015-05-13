% OM GAM GANAPATHAYE NAMA:
% function to find the max right and left line
%%%%%%%%%%%%%%%%%%%%%% HOUGH LINES END %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Marking the lines
function markings=find_lines(lines)
    max_len_r=0;
    max_len_l=0;
    max_len_h=0;
     line_right= struct('point1',{[0,0]},'point2',{[0,0]},'theta',0,'rho',0);
     line_left= struct('point1',{[0,0]},'point2',{[0,0]},'theta',0,'rho',0);
     line_horizontal= struct('point1',{[0,0]},'point2',{[0,0]},'theta',0,'rho',0);


if(~isempty(lines))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % shifting the theta values to 360 degree
    
    shiftedTheta=num2cell([lines.theta]+180);
    [lines.theta]=deal(shiftedTheta{:});
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for k = 1:length(lines)
         xy = [lines(k).point1; lines(k).point2];

      % determine the endpoints of the longest right line segment 
         if(lines(k).theta>100 && lines(k).theta<170)    %second quadrant
         len = norm(lines(k).point1 - lines(k).point2);
            if ( len > max_len_r)
             max_len_r = len;
             xy_long = xy;
             line_right= lines(k);
             line_right.theta=line_right.theta-180;
            else line_right.theta=0;
            end
         end 
       % determine the endpoints of the longest left line segment
       if(lines(k).theta>190 && lines(k).theta<260) % third quadrant
         len = norm(lines(k).point1 - lines(k).point2);
         if ( len > max_len_l)
           max_len_l = len;
           ab_long = xy;
           line_left= lines(k);
           line_left.theta=line_left.theta-180;
         else
             line_left.theta=0;
        end
       end 
       % determine the endpoints of the longest horizontal line segment
       if((lines(k).theta>80 && lines(k).theta<100) || (lines(k).theta> 260 && lines(k).theta<280)) % third quadrant || (lines(k).theta> 260 && lines(k).theta<280))
         len = norm(lines(k).point1 - lines(k).point2);
         if ( len > max_len_h)
           max_len_h = len;
           cd_long = xy;
           line_horizontal= lines(k); %values will be in 360 degree
           %line_horizontal.theta=line_horizontal.theta-180;
         else
             line_horizontal.theta=0;
        end
       end 
    end
else
    markings=[line_left, line_right, line_horizontal];       %return 0
end
    %Returning the values of the thetas to perform the lane action
    markings=[line_left, line_right, line_horizontal];
%     plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','cyan');
%     plot(ab_long(:,1),ab_long(:,2),'LineWidth',2,'Color','red');
%     plot(ab_long(:,1),cd_long(:,2),'LineWidth',2,'Color','yellow');