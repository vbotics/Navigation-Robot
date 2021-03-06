% Green Color detection
function colorValue = green_colorDetection(currFrame, objFlag,bnw)
colorValue=struct('color','no','greenObjectsMask',bnw);
eightBit= true;
if(objFlag==1)
[rgbImage storedColorMap] = imread('dump.jpg');
[rows columns numberOfColorBands] = size(rgbImage);
% subplot(3,3,1);
% imshow(rgbImage);
    
    % If it's monochrome (indexed), convert it to color. 
	% Check to see if it's an 8-bit image needed later for scaling).
	if strcmpi(class(rgbImage), 'uint8')
		% Flag for 256 gray levels.
		eightBit = true;
	else
		eightBit = false;
	end
if numberOfColorBands == 1
		if isempty(storedColorMap)
			% Just a simple gray level image, not indexed with a stored color map.
			% Create a 3D true color image where we copy the monochrome image into all 3 (R, G, & B) color planes.
			rgbImage = cat(3, rgbImage, rgbImage, rgbImage);
		else
			% It's an indexed image.
			rgbImage = ind2rgb(rgbImage, storedColorMap);
			% ind2rgb() will convert it to double and normalize it to the range 0-1.
			% Convert back to uint8 in the range 0-255, if needed.
			if eightBit
				rgbImage = uint8(255 * rgbImage);
			end
        end
    end 
else
    [rgbImage]=currFrame;
    [rows columns numberOfColorBands] = size(currFrame);
end

% Extract out the color bands from the original image
% into 3 separate 2D arrays, one for each color component.
	redBand = rgbImage(:, :, 1); 
	greenBand = rgbImage(:, :, 2); 
	blueBand = rgbImage(:, :, 3); 
    
%     % Display them.
% 	subplot(3, 3, 2);
% 	imshow(redBand);
% 	title('Red Band');
% 	subplot(3, 3, 3);
% 	imshow(greenBand);
% 	title('Green Band');
% 	subplot(3, 3, 4);
% 	imshow(blueBand);
% 	title('Blue Band');
    
% Assign the low and high thresholds for each color band.
        redThresholdLow = 0;
		redThresholdHigh = graythresh(redBand);
		greenThresholdLow = graythresh(greenBand);
		greenThresholdHigh = 255;
		blueThresholdLow = 0;
		blueThresholdHigh = graythresh(blueBand);
        
        if eightBit
			redThresholdHigh = uint8(redThresholdHigh * 255);     %changed from low to high
			greenThresholdLow = uint8(greenThresholdLow * 255);    % High to low
			blueThresholdHigh = uint8(blueThresholdHigh * 255);
        end
        %greenThresholdLow;
        
% Now apply each color band's particular thresholds to the color band
	redMask = (redBand >= redThresholdLow) & (redBand <= redThresholdHigh);
	greenMask = (greenBand >= greenThresholdLow) & (greenBand <= greenThresholdHigh);
	blueMask = (blueBand >= blueThresholdLow) & (blueBand <= blueThresholdHigh);
    
% % Display the thresholded binary images.
	
	%subplot(3, 3, 5);
	%imshow(redMask, []);
	%title('Is-Green Mask');
	%subplot(3, 3, 3);
% 	imshow(greenMask, []);
% 	title('Is-Not-Green Mask');
% 	subplot(3, 3, 4);
% 	imshow(blueMask, []);
% 	title('Is-Not-Blue Mask');
	% Combine the masks to find where all 3 are "true."
	% Then we will have the mask of only the red parts of the image.
	greenObjectsMask = uint8(redMask & greenMask & blueMask);
	%subplot(3, 3, 4);
	%imshow(greenObjectsMask, []);
	%caption = sprintf('Mask of Only\nThe Red Objects');
	%title(caption);
    
% filter out small objects.
    smallestAcceptableArea = 100;
    greenObjectsMask = uint8(bwareaopen(greenObjectsMask, smallestAcceptableArea));
	%subplot(3, 3, 5);
	%imshow(greenObjectsMask, []);
	%caption = sprintf('bwareaopen() removed objects\nsmaller than %d pixels', smallestAcceptableArea);
    %title(caption);
    
% Smooth the border using a morphological closing operation, imclose().
	structuringElement = strel('disk', 4);
	greenObjectsMask = imclose(greenObjectsMask, structuringElement);
	%subplot(3, 3, 6);
	%imshow(greenObjectsMask, []);
	%title('Border smoothed');
    
% Fill in any holes in the regions, since they are most likely red also.
	greenObjectsMask = uint8(imfill(greenObjectsMask, 'holes'));
	subplot(3, 3, 6);
	imshow(greenObjectsMask, []);
	%title('Regions Filled');
    
    % Save the binary image in the root folder
     greenObjectsMask = uint8( greenObjectsMask ) * 255;
     if(objFlag==1)
     imwrite( greenObjectsMask, 'green.jpg');
     end
% this can return the value of the color in the image and this image can be
% sent  to find the shape of the object.

% Measure the mean RGB and area of all the detected blobs.
	[meanRGB, areas, numberOfBlobs] = MeasureBlobs(greenObjectsMask, redBand, greenBand, blueBand);
	if numberOfBlobs > 0
% 		fprintf(1, '\n----------------------------------------------\n');
% 		fprintf(1, 'Blob #, Area in Pixels, Mean R, Mean G, Mean B\n');
% 		fprintf(1, '----------------------------------------------\n');
% 		for blobNumber = 1 : numberOfBlobs
% 			fprintf(1, '#%5d, %14d, %6.2f, %6.2f, %6.2f\n', blobNumber, areas(blobNumber), ...
% 				meanRGB(blobNumber, 1), meanRGB(blobNumber, 2), meanRGB(blobNumber, 3));
%         end
        colorValue.color = 'green';
        colorValue.greenObjectsMask = greenObjectsMask;
	else
		% Alert user that no red blobs were found.
% 		message = sprintf('No green blobs were found in the image:\n%s', fullImageFileName);
% 		fprintf(1, '\n%s\n', message);
% 		uiwait(msgbox(message));
        colorValue.color = 'no';
        colorValue.greenObjectsMask = greenObjectsMask;
	end
