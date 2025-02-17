clear all
close all

I  = imread('coins.png');

% Rotate the image.
%rotI = imrotate(I, 33, 'crop');

% Create a binary image.
BW = edge(I, 'canny');

% Create the Hough transform using the binary image.
[H,T,R] = hough(BW);

% Define the radius range for circle detection.
minRadius = 10;
maxRadius = 30;

% Define the step size for radius.
radiusStep = 1;

% Define the threshold for circle detection.
%threshold = 0.5 * max(H(:));

% Initialize the accumulator array for the Hough circle transform.
[rows, cols] = size(BW);
accArray = zeros(rows, cols, maxRadius);

% Perform the Hough circle transform manually.
for r = minRadius:maxRadius
    for x = 1:cols
        for y = 1:rows
            if BW(y, x) == 1
                for theta = 1:360
                    a = round(x - r * cos(theta * pi / 180));
                    b = round(y + r * sin(theta * pi / 180));

                    if a >= 1 && a <= cols && b >= 1 && b <= rows
                        accArray(b, a, r - minRadius + 1) = accArray(b, a, r - minRadius + 1) + 1;
                    end
                end
            end
        end
    end
end

% Find the peaks in the accumulator array.
numPeaks = 5; % Number of peaks to detect
peakThreshold = ceil(0.3 * max(accArray(:)));
[~, peakIndex] = sort(accArray(:), 'descend');
peakIndex = peakIndex(1:numPeaks);
[y, x, rIndex] = ind2sub(size(accArray), peakIndex);
r = rIndex + minRadius - 1;
circles = [x, y, r];

% Plot the original image with detected circles.
figure, imshow(I), hold on
for n = 1:size(accArray, 3)
    x = circles(n, 1);
    y = circles(n, 2);
    r = circles(n, 3);
    theta = linspace(0, 2*pi, 100);
    circleX = x + r * cos(theta);
    circleY = y + r * sin(theta);
    plot(circleX, circleY, 'LineWidth', 2, 'Color', 'cyan');
end
