% Om Gam Ganapathaye Nama:
% The main robot program

%cleaning up
clc;
fprintf('Wait Please... Clearing the memory');
close all;
imaqreset
clear all;
delete(instrfindall);                   % Clear the interface values
instructions=2;     % order of the map

%%%%%%%%%%%%%%%%%%%%%%%%% MAP-PROCESSING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Change the current folder to the folder of this m-file.
% (The line of code below is from Brett Shoelson of The Mathworks.)
if(~isdeployed)
	cd(fileparts(which(mfilename)));
end

%Setting the folder as current home folder
	startingFolder = pwd;

%Using the UI to select the image file
continueWithAnother = true;
promptMessage = sprintf('Please specify a lane image (in the next window).\nThis program will attempt to solve the Map-Processing.');
button = questdlg(promptMessage, 'Map-Processing', 'OK', 'Cancel', 'OK');
if strcmpi(button, 'Cancel')
	continueWithAnother = false;
end

while continueWithAnother
	% Get the name of the maze image file that the user wants to use.
	defaultFileName = fullfile(startingFolder, '*.*');
	[baseFileName, folder] = uigetfile(defaultFileName, 'Select lane image file');
	if baseFileName == 0
		% User hit cancel.  Bail out.
		return;
	end
	fullFileName = fullfile(folder, baseFileName);
    
    %Open the Lane image file.
    RGB = imread(fullFileName);
    %Saravana's Map-Processing Code
    mapValue= struct('color','red','shape','square');
    nextPosition='left';
    break;
end
IMG=RGB;
GRAY = rgb2gray(RGB);
my_image = im2double(GRAY);

image_thresholded = my_image;
image_thresholded(my_image>0.98) = 0;
%imshow(image_thresholded)


bw=im2bw(image_thresholded,0.1);
bw=bwareaopen(bw,30);
%imshow(bw);

[B,L] = bwboundaries(bw,'noholes');

% Step 6: Determine objects properties
STATS = regionprops(L, 'all'); % we need 'BoundingBox' and 'Extent'
tblob=length(STATS);
% Step 7: Classify Shapes according to properties
% Square = 3 = (1 + 2) = (X=Y + Extent = 1)
% Rectangular = 2 = (0 + 2) = (only Extent = 1)
% Circle = 1 = (1 + 0) = (X=Y , Extent < 1)

% UNKNOWN = 0

figure,
imshow(RGB),
title('Results');
hold on
for i = 1 : length(STATS)
  W(i) = uint8(abs(STATS(i).BoundingBox(3)-STATS(i).BoundingBox(4)) < 20);
  W(i) = W(i) + 2 * uint8((STATS(i).Extent - 1) == 0 );
  
  if (STATS(i).Extent<0.777)
      
    if (norm([STATS(i).Extrema(1,1), STATS(i).Extrema(1,2)]-[STATS(i).Extrema(2,1), STATS(i).Extrema(2,2)])<5) %TR,TL
    
        if (norm([STATS(i).Extrema(2,1), STATS(i).Extrema(2,2)]-[STATS(i).Extrema(3,1), STATS(i).Extrema(3,2)])<5) %RT,RB
            W(i)=4; %Triangle left
            blob(i)='T';
        else
    
            if  (norm([STATS(i).Extrema(5,1), STATS(i).Extrema(5,2)]-[STATS(i).Extrema(6,1), STATS(i).Extrema(6,2)])<5)
                if (norm([STATS(i).Extrema(8,1), STATS(i).Extrema(8,2)]-[STATS(i).Extrema(1,1), STATS(i).Extrema(1,2)])<5)
                    W(i)=4; %Triangle right
                    blob(i)='T';
                else
                    W(i)=6;%hexagon Veritical
                    blob(i)='T';
                end
            else
                W(i)=4; %Triangle upward
                blob(i)='T';
            end
        end
    else
        if (norm([STATS(i).Extrema(5,1), STATS(i).Extrema(5,2)]-[STATS(i).Extrema(6,1), STATS(i).Extrema(6,2)])<5)
               W(i)=4; %Triangle down ward
               blob(i)='T';
        else
          W(i)=6; %Hexagon horizontel
          blob(i)='H';
        end
    end
  end
if (W(i)==1)
    blob(i)='C';
else if (W(i)==2)
        blob(i)='R';
    else if(W(i)==3)
            blob(i)='S';
        end
    end
end

centroid = STATS(i).Centroid;  
farray = reshape([STATS.Centroid],2,[]);
array=int32(farray);
nblob(i)=blob(i);
kblob(i)=W(i);

switch W(i)
      case 1
          plot(centroid(1),centroid(2),'wO'); %Circle
      case 2
          plot(centroid(1),centroid(2),'wX'); %Rectangle
      case 3
          plot(centroid(1),centroid(2),'wS'); %Square
      case 4
          plot(centroid(1),centroid(2),'b*'); %Triangle
      case 5
          plot(centroid(1),centroid(2),'b+'); %Pentagon
      case 6
          plot(centroid(1),centroid(2),'b.'); %hexagon

end

end
        yellow=[255 242 0];
        Yellow=[255 255 0];
        Red=[255 0 0];
        Blue=[0 0 255];
        Green=[0 255 0];
        Brown=[185 122 87];
        White=[255 255 255];
        Black=[0 0 0];
        Pink=[240 31 191];
        Purpel=[240 31 191];
        Skyblue=[0 255 255];
        
        
for(i=1:length(STATS))
    shape(i).cen=array(:,i);
    shape(i).num=kblob(:,i);
    shape(i).nam=nblob(i);
   
    
            x=shape(i).cen(1,1);
            y=shape(i).cen(2,1);
    
            for j=1:3;
                red(j)=RGB(y,x,j);
            end
            shape(i).color=red;
    
        if (red(1)>230)
                    if(red(2)>230)
                        if(red(3)<50)
                shape(i).c='Y';
                        end
                    end
          
        else  if(red(1)>230)
                    if(red(2)<50)
                        if(red(3)<50)
                shape(i).c='R';
                        end
                    end
                             
        else if(red(1)<50)
                    if(red(2)<50)
                        if(red(3)>230)
                shape(i).c='L';
                        end
                    end
                
              else
                    if(red(1)<50)
                    if(red(2)>230)
                        if(red(3)<50)
                shape(i).c='G';
                        end
                    end
               
                    else
                        shape(i).c='B';
                                    end
            end
            end
        end

       
        
  if(shape(i).c=='Y')
     shape(i).order=1;
     map(1).cen=shape(i).cen;
        map(i).color=shape(i).color;
        map(i).num=shape(i).num;
        map(i).nam=shape(i).nam;
        map(i).cen
  end
  
end


or=1;
n=1;
z=1;
cenflag=0;
[r c d]=size(RGB);
imshow(RGB);


for i=1:tblob
	x=shape(i).cen(1,:);
	y=shape(i).cen(2,:);
    xi=x;  yi=y;
    w=0;flag=0;
	y=y-1;
    
		%TOP CHECKING
        
			for(trail=1:1000)
                color_val=color(y,x,RGB);
                RGB(y,x,1)=240;
                RGB(y,x,2)=31;
                RGB(y,x,3)=191;
				if((color_val==shape(i).color)&w==0)
					if(y>5)
                        y=y-1;
                    end      %x=x-1;
                else if (color_val==White)
						w=1;
						if(y>5)
                        y=y-1; 
                    end	%x=x-1;
					else if(color_val==Black)
							break;
                        else %T juction
                            if (color_val==Purpel)                               
                               order(or).order=[xi,yi,x,y];
                               or=or+1;
                               new(n).line=[x;y]; n=n+1;
                               RGB=m_line(xi,yi,x,y,RGB);   
                               flag=1;
                               
                            else
								for i=1:tblob
									xa=shape(i).cen(1,:);
									ya=shape(i).cen(2,:);
									colorval=color(y,x,IMG);
                                        if(y>ya)
                                           if(x-40<xa<x+40)
                                                if (colorval==shape(i).color)
                                                xj=xi; 
                                                yj=ya;
                                                shape(i).cen(1,:)=xi;
                                                order(or).order=[xi,yi,xj,yj];
                                                or=or+1;
                                                RGB=m_line(xi,yi,xi,yj,RGB);   
                                                flag=1;
                                                break;
                                            end
                                        end
                                    end
                                end
                            end
						end
					end
                end
               if (flag==1)
                 break;
               end
                
            end
         imshow(RGB);   
end

for i=1:tblob
	x=shape(i).cen(1,:);
	y=shape(i).cen(2,:);
    xi=x;  yi=y;
    w=0;flag=0;
    x=x+1;
	
		
		%RIGHT CHECKING
        
			for(trail=1:1000)
                color_val=color(y,x,RGB);
                RGB(y,x,1)=128;
                RGB(y,x,2)=0;
                RGB(y,x,3)=128;
             
				if((color_val==shape(i).color)&w==0)
                   if(c-5>x)
                       x=x+1;
                   end
				else if (color_val==White)
						w=1;
                        if(c-5>x)
                            x=x+1;
                        end
                    else if(color_val==Black)
							break;
                         else %T juction
                            if(color_val==Pink)
                                order(or).order=[xi,yi,x,y];
                                or=or+1;
                                new(n).line=[x;y]; n=n+1;
                                RGB=m_line(xi,yi,x,y,RGB);
                                flag=1;
                                
                            else
								for i=1:tblob
									xa=shape(i).cen(1,:);
									ya=shape(i).cen(2,:);
                                    if (color_val==shape(i).color)
                                        if(x<xa)
                                            if((y-20<ya)&(ya<y+20))
                                                yj=yi; 
                                                xj=xa;
                                                shape(i).cen(2,:)=yj;
                                                order(or).order=[xi,yi,xj,yj];
                                                or=or+1;
                                                RGB=m_line(xi,yi,xj,yj,RGB);   
                                                flag=1;
                                                break;
                                            end
                                        end
                                    end
                                end
                            end
						end
					end
                end
               if (flag==1)
                 break;
               end
            
            end
       imshow(RGB);
end
a=5;
for i=1:tblob
	x=shape(i).cen(1,:);
	y=shape(i).cen(2,:);
    xi=x;  yi=y;
    w=0;flag=0;
	y=y+1;
	x=x+a;
		%down CHECKING
        
			for(trail=1:1000)
                if(y>=r-5)
                    break;
                end
                color_val=color(y,x,RGB);
                if((color_val==shape(i).color)&w==0)
					if(r-5>y)
                        y=y+1;
                    end  %x=x-1;
				else if (color_val==White)
						w=1;
						if(r-5>y)
                        y=y+1; 
                    end	%x=x-1;
					else if(color_val==Black)
                            x=x-a;
                            RGB=vertical(xi,yi,x,y,RGB);
							break;
                        else %T juction
                            if (color_val==Purpel)
                               x=x-a;
                               order(or).order=[xi,yi,x,y];
                               or=or+1; 
                               new(n).line=[x;y]; n=n+1;
                               RGB=m_line(xi,yi,x,y,RGB);   
                               flag=1;
                               
                            
                                else for i=1:tblob
                                        
									xa=shape(i).cen(1,:);
									ya=shape(i).cen(2,:);
									 if (color_val==shape(i).color)
                                        if(x-40<xa<x+40)
                                            if(y-86<ya<y)
                                                xj=xa;
                                                yj=ya;
                                                
                                                if(color_val==shape(i).color)
                                                order(or).order=[xi,yi,xj,yj];
                                                or=or+1;
                                                RGB=m_line(xi,yi,xj,yj,RGB);   
                                                flag=1;
                                                break;
                                            end
                                        end
                                    end
                                end
                            end
                            
                            end
						end
					
                end
               if (flag==1)
                 break;
               end
               
                end
            end
         imshow(RGB); 
end

for i=1:tblob
	x=shape(i).cen(1,:);
	y=shape(i).cen(2,:);
    xi=x;  yi=y;
    w=0;flag=0;
	x=x-1;
    y=y+a;
		
		%LEFT CHECKING
        
			for(trail=1:1000)
                if(x<=5)
                    break;
                end
                color_val=color(y,x,RGB);
               if((color_val==shape(i).color)&w==0)
                  if(x>5)
                      x=x-1;
                  end
				else if (color_val==White)
						w=1;
                        if(x>5)
                            x=x-1;
                        end
                    else if(color_val==Black)
                            y=y-a;
                             RGB=vertical(xi,yi,x,y,RGB);
							break;
                         else %T juction
                            if (color_val==Pink)
                                y=y-a;
                                order(or).order=[xi,yi,x,y];
                                or=or+1;
                                new(n).line=[x;y]; n=n+1;
                                RGB=m_line(xi,yi,x,y,RGB);
                                flag=1;
                            else
                                
								for i=1:tblob
                                    y=y-a;
									xa=shape(i).cen(1,:);
									ya=shape(i).cen(2,:);
                                    if (color_val==shape(i).color)
                                        if(x<xa<x+80)
                                            if(y-40<ya<y+40)
                                                order(or).order=[xi,yi,xj,yj];
                                                or=or+1;
                                                RGB=m_line(xi,yi,xj,yj,RGB);   
                                                flag=1;
                                                break;
                                            end
                                        end
                                    end
                                
                            end
						end
                        end
                    end
                end
               if (flag==1)
                 break;
               end
                
            end
    imshow(RGB);   
end
tl=n;
n=n-1;
k=tblob;
for (z=1:100)
    if(n>0)
        k=k+1;
        shape(k).cen=new(n).line;
        n=n-1;
   
    end
    if (n==0)
        break;
    end
end

l=tl-1;

for(t=1:l)
    xc=new(t).line(1,:);
    yc=new(t).line(2,:);
    for(j=1:k)
        x=shape(j).cen(1,:);
        y=shape(j).cen(2,:);
        if((xc==x)&(yc==y))
            break;
        else
        if(xc==x)
            RGB=m_line(xc,yc,x,y,RGB);
        else
       
            RGB=m_line(xc,yc,x,y,RGB);
       
        end
        end
    end
end



% for(i=1:tblob)
%     if (shape(i).order==1)
%         map(i).cen=shape(i).cen;
%         map(i).color=shape(i).color;
%         map(i).num=shape(i).num;
%         map(i).nam=shape(i).nam;
%     end
% end
IMG=RGB;
img=rgb2gray(IMG);
threshold=img;
threshold(img>179)=0;
threshold(img<179)=0;
threshold(img==179)=255;
imshow(RGB)
%imshow(threshold);

o=0; order=1;xflag=0;yflag=0;
for (j=1:k)
    order=order+1; o=o+1;
    if (j==1)
        x=map(1).cen(1,:);
        y=map(1).cen(2,:);
        for(i=1:k)
            xi=shape(i).cen(1,1);
            yi=shape(i).cen(2,1);
            if((x==xi)&(y==yi))
                continue;
            else
                if(x==xi)
                    map(order).cen(1,1)=xi;
                    map(order).cen(2,1)=yi;
                    xflag=1;
                    break;
                else
                    if(y==yi)
                    map(order).cen(1,1)=xi;
                    map(order).cen(2,1)=yi;
                    yflag=1;
                    break;
                    end
                end
            end
        end
    end
    
    x=map(o).cen(1,1);
    y=map(o).cen(2,1);
    
    for(i=1:k)
        xi=shape(i).cen(1,1);
        yi=shape(i).cen(2,1);
        if((x==xi)&&(y==yi))
                continue;
        else
        if(xflag==1)
            if(y==yi)
                map(order).cen(1,1)=xi;
                map(order).cen(2,1)=yi;
                xflag=0;
                yflag=1;
                break;
            end
        end
        
        if (yflag==1)
            if(x==xi)
                map(order).cen(1,1)=xi;
                map(order).cen(2,1)=yi;
                xflag=1;
                yflag=0;
                break;
            end
        end
        end
    end
end


%DIRECTION PROGRAM

n=k-1;
for(i=1:n)
    c=i+1;
    x=map(i).cen(1,1);
    y=map(i).cen(2,1);
    xi=map(c).cen(1,1);
    yi=map(c).cen(2,1);
    if(y==yi)
        if(x>xi)
            map(i).direction='LEFT';
        else
            if(x<xi)
                map(i).direction='RIGHT';
            end
        end
    else
    
    if(x==xi)
        if(y>yi)
            map(i).direction='UP';
        else
            if (y<yi)
                map(i).direction='DOWN';
            end
        end
    end
    end
end

%INSTRUCTION PROGRAM

tm=k;
map(1).ins='FORWARD';
for(g=2:tm)
    n=g-1;
    x=map(n).direction;
    y=map(g).direction;
    if strcmp(x,'RIGHT')&&strcmp(y,'DOWN')        
        map(g).ins='RIGHT';
    else
        if strcmp(x,'RIGHT')&&strcmp(y,'UP')
            map(g).ins='LEFT';
        else
            if strcmp(x,'LEFT')&&strcmp(y,'DOWN')
                map(g).ins='LEFT';
            else
                if strcmp(x,'LEFT')&&strcmp(y,'UP')
                    map(g).ins='RIGHT';
                else
                    if strcmp(x,'DOWN')&&strcmp(y,'RIGHT')
                        map(g).ins='LEFT';
                    else
                        if strcmp(x,'DOWN')&&strcmp(y,'LEFT')
                            map(g).ins='RIGHT';
                        else
                            if strcmp(x,'UP')&&strcmp(y,'RIGHT')
                                map(g).ins='RIGHT';
                            else
                                if strcmp(x,'UP')&&strcmp(y,'LEFT')
                                    map(g).ins='LEFT';
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end


for(i=1:k)
    for(j=1:tblob)
        if (map(i).cen==shape(j).cen)
            map(i).color=shape(j).color;
            map(i).shape=shape(j).nam;
            map(i).cname=shape(j).c;
        end
    end
end


map(k).ins='STOP';
  
%%%%%%%%%%%%%%%%%%%%%%%%%% MAP-PROCESSING END %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% REAL-TIME VIDEO PROCESSING STARTS %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initiating the video live feed
fprintf('\n Live-Video grabbing initiated');
vidobj = videoinput('winvideo',2, 'YUY2_640x480');      % creates a video input object
set(vidobj,'FramesPerTrigger',1);       % set the property of a object
set(vidobj,'TriggerRepeat',inf);        
triggerconfig(vidobj,'manual');         % configure video input object trigger setting
start(vidobj);                          % Start timer(s) running.

s = serial('COM8', 'BaudRate', 9600); % Serial Port Initialization 
set(s,'outputbuffersize',1024);
fopen(s);
objFlag=1;
turnFlag=0;
pivotFlag=0;
blobFollow=0;
fwdFlag=0;
pause(3);       %Time to initialize the camera and get ready

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

while(1)
    trigger(vidobj);
    currFrame = getdata(vidobj);   % Take snapshot
    currFrame = ycbcr2rgb(currFrame);
    
    %dumping the image to send to color and shape detection
    if( objFlag==1 )
        bnw=im2bw(currFrame);
        bnw = uint8(bnw) * 255;
    imwrite(currFrame, 'dump.jpg');
    pause(0.03);
    colorValueRed = red_colorDetection(currFrame,objFlag,bnw);
    colorValueGreen = green_colorDetection(currFrame,objFlag,bnw);
    colorValueBlue = blue_colorDetection(currFrame,objFlag,bnw);
    
    if(strcmp(colorValueRed.color,'red'))
        maincolorValue='red';
    elseif(strcmp(colorValueGreen.color,'green'))
        maincolorValue='green';
    elseif(strcmp(colorValueBlue.color,'blue'))
        maincolorValue='blue';
    elseif(strcmp(colorValueRed.color,'no') && strcmp(colorValueGreen.color,'no') && strcmp(colorValueBlue.color,'no'))
        maincolorValue='no';
    end
    % function to detect the shape of the object with ref to colorValue
    if(strcmp(maincolorValue,'no'))
        colorShape.color=0;
        colorShape.shape='unknown';
    else
    colorShape = shapedetCircularities(maincolorValue);
    end
    blobFollow=0;
    objFlag=0;      % once detected need not check until the bot stops for a turn
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% WHITE LANE BLOB %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     if(strcmp(maincolorValue,'no')) 
     Gframe=rgb2gray(currFrame);    
     [r c d]=size(Gframe);
     output_image=zeros(r,c);
     %Gframe = im2bw(frame);
     %Detect whites
     for i1=1:r
         for i2=1:c
              if(Gframe(i1,i2)>200)
                 output_image(i1,i2)=1;
             else
                 output_image(i1,i2)=0;
             end
         end
     end
         
     subplot(3,3,1) 
     imshow(output_image);
     title('lane');
     
     [r_cent c_cent]=centroidd(output_image);
     total_pix=sum(sum(output_image));
   disp('Total Pixel=');
   disp(total_pix);
   if(fwdFlag==0)
   if((total_pix<100000))  
              
       if ((c_cent<310))
         disp('left()');
         fprintf(s,'l');
         pause(0.03);
         fprintf(s,'s');
        %delay(30);
       elseif ((c_cent>330))
         disp('right()');
         fprintf(s,'r');
         pause(0.03);
         fprintf(s,'s');
         %delay(30);
       else
           disp('forward()');
            fprintf(s,'f');
            pause(0.06);
            fprintf(s,'s');
            fwdFlag=1;
       end
   end
   else
       if(total_pix>0)
       fprintf(' GO FWD');
       fprintf(s,'f');
       pause(0.7);
       fprintf(s,'s');
       else
           fprintf('STOPP');
           fprintf(s,'s');
           turnFlag=1;
           fwdFlag=0;
       end
   end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BLOB-NAV %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% blob_nav for red object
if(blobFollow==0)
    
if(strcmp(maincolorValue,'red'))
    chumma = red_colorDetection(currFrame,objFlag,bnw);
    im_red = chumma.redObjectsMask;
    blobFollows = blob_nav(im_red, s);
    blobFollow=blobFollows;
    if(blobFollows==1)   % turn completed
        turnFlag=1;
    end
else

% blob_nav for green object
if(strcmp(maincolorValue,'green'))
    chumma = green_colorDetection(currFrame,objFlag,bnw);
    im_green = chumma.greenObjectsMask;
    blobFollows = blob_nav(im_green,s);
    blobFollow=blobFollows;
    if(blobFollows==1)   % turn completed
        turnFlag=1;
    end
else

% blob_nav for blue object
if(strcmp(maincolorValue,'blue'))
    chumma = blue_colorDetection(currFrame,objFlag,bnw);
    im_blue = chumma.blueObjectsMask;
    blobFollows = blob_nav(im_blue,s);
    blobFollow=blobFollows;
    if(blobFollows==1)   % turn completed
        turnFlag=1;
    end
end
end
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%% CHECKING AND PIVOTING %%%%%%%%%%%%%%%%%%%%%%%%%%%

% if turnFlag is SET then the robot needs to pivot according to the map
% value. Hence check the next map value: mapValue+1/nextPosition
    
if(turnFlag==1 || blobFollow==1)
   % pause(0.05);
    fprintf('\n inside pivot');
    if(colorShape.color==1  && strcmp(map(instructions).cname,'R') && strcmp(map(instructions).shape,'S'))
    pivotFlags = pivot(map(instructions),  s);
    pivotFlag=pivotFlags;
    turnFlag=0;
    fprintf('\n inside red square');
          % turned on to check while in the next run to detect.
    else
    
    if(colorShape.color==2  && strcmp(map(instructions).cname,'G') && strcmp(map(instructions).shape,'S'))
    pivotFlags = pivot(map(instructions),  s);
    pivotFlag=pivotFlags;
    turnFlag=0;
    fprintf('\n inside green square');
    %objFlag=1;      % turned on to check while in the next run to detect.
    else
    
    if(colorShape.color==3  && strcmp(map(instructions).cname,'L') && strcmp(map(instructions).shape,'S'))
    pivotFlags = pivot(map(instructions),  s);
    pivotFlag=pivotFlags;
    turnFlag=0;
    fprintf('\n inside blue square');
    %objFlag=1;      % turned on to check while in the next run to detect.
    else
    
    if(colorShape.color==1  && strcmp(map(instructions).cname,'R') && strcmp(map(instructions).shape,'C'))
    pivotFlags = pivot(map(instructions),  s);
    pivotFlag=pivotFlags;
    turnFlag=0;
    fprintf('\n inside red circle');
    %objFlag=1;      % turned on to check while in the next run to detect.
    else
    
    if(colorShape.color==2  && strcmp(map(instructions).cname,'G') && strcmp(map(instructions).shape,'C'))
    pivotFlags = pivot(map(instructions),  s);
    pivotFlag=pivotFlags;
    turnFlag=0;
    fprintf('\n inside green circle');
    %objFlag=1;      % turned on to check while in the next run to detect.
    else
    
    if(colorShape.color==3 && strcmp(map(instructions).cname,'L') && strcmp(map(instructions).shape,'C'))
    pivotFlags = pivot(map(instructions),  s);
    pivotFlag=pivotFlags;
    turnFlag=0;
    fprintf('\n inside blue circle');
    %objFlag=1;      % turned on to check while in the next run to detect.
    else
    
    if(colorShape.color==1 && strcmp(map(instructions).cname,'R') && strcmp(map(instructions).shape,'T'))
    pivotFlags = pivot(map(instruction), s);
    pivotFlag=pivotFlags;
    turnFlag=0;
    fprintf('\n inside red triangle');
    %objFlag=1;      % turned on to check while in the next run to detect.
    else
    
    if(colorShape.color==2  && strcmp(map(instructions).cname,'G') && strcmp(map(instructions).shape,'T'))
    pivotFlags = pivot(map(instructions),  s);
    pivotFlag=pivotFlags;
    turnFlag=0;
    fprintf('\n inside green triangle');
    %objFlag=1;      % turned on to check while in the next run to detect.
    else
    
    if(colorShape.color==3  && strcmp(map(instructions).cname,'L') && strcmp(map(instructions).shape,'T'))
    pivotFlags = pivot(map(instructions),  s);
    pivotFlag=pivotFlags;
    turnFlag=0;
    fprintf('\n inside blue triangle');
    %objFlag=1;      % turned on to check while in the next run to detect.
    else
        
    if(colorShape.color==1 && strcmp(map(instructions).cname,'R') && strcmp(map(instructions).shape,'H'))
    pivotFlags = pivot(map(instructions),  s);
    pivotFlag=pivotFlags;
    turnFlag=0;
    fprintf('\n inside red hexagon');
    %objFlag=1;      % turned on to check while in the next run to detect.
    else
    
    if(colorShape.color==2  && strcmp(map(instructions).cname,'G') && strcmp(map(instructions).shape,'H'))
    pivotFlags = pivot(map(instructions),  s);
    pivotFlag=pivotFlags;
    turnFlag=0;
    fprintf('\n inside green hexagon');
    %objFlag=1;      % turned on to check while in the next run to detect.
    else
    
    if(colorShape.color==3 && strcmp(map(instructions).cname,'L') && strcmp(map(instructions).shape,'H'))
    pivotFlags = pivot(map(instructions),  s);
    pivotFlag=pivotFlags;
    turnFlag=0;
    fprintf('\n inside blue hexagon');
    %objFlag=1;      % turned on to check while in the next run to detect.
    else
    
    if(colorShape.color==0  && isempty(map(instructions).cname) && isempty(map(instructions).shape))
    pivotFlags = pivot(map(instructions),  s);
    fprintf(s,'s');     % stop the program and exit
    pivotFlag=pivotFlags;
    turnFlag=0;
    fprintf('\n inside T-Junction');
    %objFlag=1;      % turned on to check while in the next run to detect.
    else
    
    if(colorShape.color==0  && strcmp(map(instructions).cname,'B'))
    pivotFlags = pivot(map(instructions),  s);
    fprintf(s,'s');     % stop the program and exit
    pivotFlag=pivotFlags;
    turnFlag=0;
    fprintf('\n inside correct');
    %objFlag=1;      % turned on to check while in the next run to detect.
    end
    end
    end
    end
    end
    end
    end
    end
    end
    end
    end
    end
    end
    end
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(pivotFlag==1)
    pause(3);
    %turn completed 
    %increment the map value: map +1
    pivotFlag=0;
    objFlag=1;
    instructions=instructions+1;
    if(instructions==length(map))       %exit the program 
        exit;
    end
end
%%%%%%%%%%%%%%%%%%%%% Continue till the end %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%stop(vidobj);
end


