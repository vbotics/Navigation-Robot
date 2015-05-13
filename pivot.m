% pivot program

function pivotFlags= pivot(INS,s)
fprintf('\n Inside pivot function');
pivotFlags=1;
if(strcmp(INS.ins,'RIGHT'))
    fprintf(s,'r');
    pause(1.5);
    fprintf(s,'s');
elseif(strcmp(INS.ins,'LEFT'))
    fprintf(s,'l');
    pause(1.5);
    fprintf(s,'s');
elseif(strcmp(INS.ins,'STOP'))
    fprintf(s,'s');
    pause(2);
    fprintf(s,'s');
    
end