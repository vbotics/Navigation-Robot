function [r_cent c_cent]=centroidd(arg)
[r_index c_index]=find(arg);
r_cent=mean(r_index);
c_cent=mean(c_index);
r_cent;
c_cent;