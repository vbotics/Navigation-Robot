%Om Gam Ganapathaye Nama:

% Program to find the blob and follow it as in the center

function blobFollows = blob_nav(frame, s)
blobFollows=0;
%frame= imread('H:\MyProjects\IITKGP\GEOAWARE\FinalRobotwithBlobNav\red.jpg');

     [r c d]=size(frame);
     output_image=zeros(r,c);
     %frame = im2bw(frame);
     %Detect whites
     for i1=1:r
         for i2=1:c
              if(frame(i1,i2)==255)
                 output_image(i1,i2)=1;
             else
                 output_image(i1,i2)=0;
             end
         end
     end
    

    %frame = im2bw(frame);
     
   [r_cent c_cent]=centroidd(output_image);
   %subplot(3,3,3); imshow(output_image);
   %title('blobl_nav');
   %disp('c_cent=');
%    k=[r_cent c_cent];
%     k;
   total_pix=sum(sum(output_image));
   disp('Total Pixel=');
   disp(total_pix);
%    total_pix;
   
   if((total_pix<90000))  
              
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
       end
   end
        if(total_pix>90000)
            blobFollows=1;
           disp('stop');
           fprintf(s,'s');
           %pause(0.05);
                 %Complete
       
        end    
%        if(total_pix<100)
%             blobFollows=1;     %incomplete
%        end
       % blobFollows=0;
   
          %Complete