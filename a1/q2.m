close all
clc
clear
% read image
im = imread('PA1-testimages/trees_var002.tif');


im2 = medfilt2(im);

filter_avg = ones(3,3); % averging filter
filter_small = [0,1,0;
           1,2,1;
           0,1,0];
       
filter_large = [0,0,1,0,0;
           0,1,3,1,0;
           1,3,5,3,1;
           0,1,3,1,0;
           0,0,1,0,0];       

% im3 = imfilter(im,filter1,'conv');
% im4 = imfilter(im,filter2,'conv');
% 
% figure, imshow(im);
% figure, imshow(im2);
% figure, imshow(im3);
% figure, imshow(im4);
figure, imshow(im),title('Original');
imwrite(im,'Original.png','png');
figure, imshow(medfilt2(im)),title('medfilt');
imwrite(im,'medfilt.png','png');
showFilteredIm(im,filter_avg,1,'Averge1x');
showFilteredIm(im,filter_avg,5,'Average5x');
showFilteredIm(im,filter_small,1,'Small1x');
showFilteredIm(im,filter_small,5,'Small5x');
showFilteredIm(im,filter_large,1,'Large1x');
showFilteredIm(im,filter_large,5,'Large5x');


function fim = showFilteredIm(im, filter, times, caption)
    amp = sum(filter(:));
    if(amp>=2)
        filter = filter/amp;
    end
    fim = imfilter(im,filter,'conv');
    for i=1:times-1
        fim = imfilter(fim,filter,'conv');
    end
    figure, imshow(fim), title(caption);%,print(caption,'-dpng');
    imwrite(fim,strcat(caption,'.png'),'png');
end