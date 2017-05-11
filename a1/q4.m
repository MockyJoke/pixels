close all
clc
clear
% read image
im = imread('PA1-testimages/trees_salt020.tif');

filter_large = [0,0,1,0,0;
           0,1,3,1,0;
           1,3,5,3,1;
           0,1,3,1,0;
           0,0,1,0,0]; 

fim=filterIm(im, filter_large,5);

showIm(im,'Original');
showIm(fim,'Smooth');

im_canny = edge(im,'Canny');
im_prewitt = edge(im,'Prewitt');
im_log = edge(im, 'log');
im_sobel = edge(im,'Sobel');
showIm(im_canny,'canny-noise');
showIm(im_prewitt,'prewitt-noise');
showIm(im_log,'log-noise');
showIm(im_sobel,'sobel-noise');

fim_canny = edge(fim,'Canny');
fim_prewitt = edge(fim,'Prewitt');
fim_log = edge(fim, 'log');
fim_sobel = edge(fim,'Sobel');
showIm(fim_canny,'canny-smooth')
showIm(fim_prewitt,'prewitt-smooth');
showIm(fim_log,'log-smooth');
showIm(fim_sobel,'sobel-smooth');

function showIm(im, caption)
    figure, imshow(im), title(caption);%,print(caption,'-dpng');
    imwrite(im,strcat(caption,'.png'),'png');
end

function fim = filterIm(im, filter, times)
    amp = sum(filter(:));
    if(amp>=2)
        filter = filter/amp;
    end
    fim = imfilter(im,filter,'conv');
    for i=1:times-1
        fim = imfilter(fim,filter,'conv');
    end
%      figure, imshow(fim), title(caption);%,print(caption,'-dpng');
%       imwrite(fim,strcat(caption,'.png'),'png');
end