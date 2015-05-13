function color_val= color(y,x,RGB)
    %RGB=imread('C:\Users\saravana\Desktop\Matlab images\two1.png');
	for j=1:3
		red(j)=RGB(y,x,j);
	end
	color_val=red;
 