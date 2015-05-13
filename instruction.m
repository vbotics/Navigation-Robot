% Function to instruct the robot
function turnFlags = instruction(markings, s) 
turnFlags=0;
if ((markings(1).theta~=0) && (markings(2).theta~=0))
    
fprintf('\n INSTRUCTIONS: ');
    if ((markings(1).theta + markings(2).theta)>-10 && (markings(1).theta + markings(2).theta<10))
        disp('\n Go forward');
        fprintf(s,'f');
        %pause(0.05);
       % fprintf(s,'s');
        
        elseif((markings(1).theta + markings(2).theta)>10)
    
            disp('\n Turn to your left');
            fprintf(s,'l');
            %pause(0.02);
           % fprintf(s,'s');
            
        elseif((markings(1).theta + markings(2).theta)<-10)
        
            disp('\n Turn to your right');
            fprintf(s,'r');
            %pause(0.02);
            %fprintf(s,'s');
    end
    turnFlags=0;
else
    if((markings(3).theta<90) || (markings(3).theta<270))
    fprintf(s,'r');
    %pause(0.02);
    %fprintf(s,'s');
    
   
    else
        if((markings(3).theta>100) || (markings(3).theta>280))
    fprintf(s,'l');
    %pause(0.02);
    %fprintf(s,'s');
    
    else
            fprintf(s,'f');
            %pause(0.05);
            if((markings(1).theta==0) && (markings(2).theta==0) && (markings(3).theta==0)) %changd
        disp('Stop');
        fprintf(s,'s');
        % go to the main and let it know that the bot is ready for turn
        turnFlags=1;
            end
            
        end
    end
    end    %reached the end of T-Junction i.e no lines detected
    
    
    

%line_left
%line_right
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
