%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File Name: reader.m
% Description: This script reads in a test image and thresholds it at 
%              gray level. You can change the threshold ciThres for 
%              different results.
% Environment: Matlab R2007a (may works fine with previous Matlab versions)
% Usage: In Matlab Command Window, type 'reader'.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clc
clear

% read image
im = imread('dark.tif');

% gray scale, get luminance
% im = rgb2gray(im);

% threshold
ciThres = 160;


im2 = mystretch(im);
im3=imadjust(im);
im4=myhisteq(im);
im5 = histeq(im);

figure, imshow(im), imwrite(im, 'original_image.png')
figure, imhist(im), title('Histogram - original image') ,print('hist_original','-dpng')


figure, imshow(im2), imwrite(im2, 'my_hist_stretch.png')
figure, imhist(im2), title('Histogram - my hist strech') ,print('hist_my_hist_stretch','-dpng')

figure, imshow(im3), imwrite(im3, 'build-in_stretch.png')
figure, imhist(im3), title('Histogram - build-in hist strech') ,print('hist_build-in_stretch','-dpng')

figure, imshow(im4), imwrite(im4, 'my_hist_equ.png')
figure, imhist(im4), title('Histogram - my histogram equ') ,print('hist_my_hist_equ','-dpng')

figure, imshow(im5), imwrite(im5, 'build-in_hist_equ.png')
figure, imhist(im5), title('Histogram - build-in histogram equ') ,print('hist_build-in_hist_equ','-dpng')
% show image
% figure, imshow(im)
% figure, imshow(im2);
% im3=imadjust(im);
% figure, imshow(im3);
% im4 = histeq(im);
% figure, imshow(im4);
% save image to file
% close all
% imwrite(im2, 'SFU_2.bmp', 'bmp');


myhisteq(im);

function img2 = mystretch(img)
    img2 = zeros(size(img));
    img2 = uint8(img2);
    im_min = min(img(:));
    im_max = max(img(:));
    for i = 1:size(img, 1)
        for j = 1:size(img, 2)
            pixel_ori = double(img(i,j));
            ratio = double(pixel_ori-im_min) / double((im_max-im_min));
            pixel_new = 255 * ratio;
            img2(i,j) = pixel_new;
        end
    end
end

function img2 = myhisteq(img)
    total_pixels=size(img,1)*size(img,2);

    MAX=256;
    freq = zeros(1,MAX);
    
    for i = 1:size(img, 1)
        for j = 1:size(img, 2)
            color = img(i,j);
            freq(1,color+1)= freq(color+1)+1;
        end
    end
    prob = zeros(1,MAX);
    for i = 1:MAX
        prob(1,i)=freq(1,i)/total_pixels;
    end
    cdf = zeros(1,MAX);
    k=0;
    for i = 1:MAX
        k = k + prob(1,i);
        cdf(1,i) = k;
    end
    expand = zeros(1,MAX);
    for i = 1:MAX
        expand(1,i) = floor(cdf(1,i) * 256);
    end
    img2 = uint8(zeros(size(img)));
    for i = 1:size(img, 1)
        for j = 1:size(img, 2)
            img2(i,j)=expand(1,img(i,j)+1);
        end
    end 

%    
%    figure, imhist(img2)
%    figure, imshow(img2)
%    im3 = histeq(img)
%    figure, imhist(im3)
%    figure, imshow(im3)
end

