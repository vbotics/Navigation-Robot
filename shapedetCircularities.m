% shape detection with circularities
% allAreas = [measurements.Area];
% allPerimeters = [measurements.Perimeter];
% circularities = allPerimeters.^2 ./ (4*pi*allAreas);

function colorShape = shapedetCircularities(colorValue)

colorShape=struct('shape','unknown','color',0); % structure to send the color and shape values

% to check what colorValue is received & to be checked
if ( strcmp(colorValue,'red'))
    binaryImage1 = imread('red.jpg');
    colorShape.color=1;
    
elseif( strcmp(colorValue,'green'))
    binaryImage1 = imread('green.jpg');
    colorShape.color=2;
    
elseif( strcmp(colorValue,'blue'))
    binaryImage1 = imread('blue.jpg');
    colorShape.color=3;
elseif( strcmp(colorValue,'no'))
    binaryImage1 = imread('dump.jpg');
    colorShape.color=0;
end

binaryImage = im2bw(binaryImage1);
[labeledImage numberOfBlobs] = bwlabel(binaryImage);     % Label each blob so we can make measurements of it

if numberOfBlobs == 0
		% Didn't detect any yellow blobs in this image.
		meanRGB = [0 0 0];
		areas = 0;
		return;
end
    

blobMeasurements = regionprops(labeledImage,'Perimeter','Area');
% for square ((a>17) && (a<20))
% for circle ((a>13) && (a<17))
% for triangle ((a>20) && (a<30))
circularities = [blobMeasurements.Perimeter.^2] ./ (4 * pi * [blobMeasurements.Area])
% Say what they are
for blobNumber = 1 : numberOfBlobs
	if circularities(blobNumber) < 1.19
% 		message = sprintf('The circularity of object #%d is %.3f, so the object is a circle',...
% 			blobNumber, circularities(blobNumber));
            colorShape.shape = 'circle';
	elseif circularities(blobNumber) < 1.53
% 		message = sprintf('The circularity of object #%d is %.3f, so the object is a square',...
% 			blobNumber, circularities(blobNumber));
            colorShape.shape = 'square';
	else
% 		message = sprintf('The circularity of object #%d is %.3f, so the object is a triangle',...
% 			blobNumber, circularities(blobNumber));
            colorShape.shape = 'triangle';
	end
% 	uiwait(msgbox(message));
end
