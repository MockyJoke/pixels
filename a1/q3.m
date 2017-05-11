close all
clc
clear
% read image
im = imread('PA1-testimages/peppers.png');


sharpen_small = [0,-1,0;
                 -1,7,-1;
                 0,-1,0];
sharpen_agressive = [-1,-2,-1;
                     -2,14,-2;
                     -1,-2,-1];
sharpen_large = [-1,-1,-1,-1,-1;
                 -1, -1, -1, -1,-1;
                 -1, -1,50, -1,-1;
                 -1, -1, -1, -1,-1;
                 -1,-1,-1,-1,-1];
     

figure, imshow(im),title('Original');
imwrite(im,'Original.png','png');

showFilteredIm(im,sharpen_small,1,'Small');
showFilteredImOnL(im,sharpen_small,1,'Small-Luminance');
showFilteredIm(im,sharpen_agressive,1,'Agressive');
showFilteredImOnL(im,sharpen_agressive,1,'Agressive-Luminance');
showFilteredIm(im,sharpen_large,1,'Large');
showFilteredImOnL(im,sharpen_large,1,'Large-Luminance');

function fim = showFilteredIm(im, filter, times, caption)
    amp = sum(filter(:));
    if(amp>=2)
        filter = filter/amp;
    end
%     fim = imfilter(im,filter,'conv');
    fim = convn(im,filter);
    for i=1:times-1
        fim = convn(fim,filter);
    end
    fim = uint8(fim);
    
    fim=resize(im,fim);
    figure, imshow(fim), title(caption);%,print(caption,'-dpng');
    imwrite(fim,strcat(caption,'.png'),'png');
end

function fim = showFilteredImOnL(im, filter, times, caption)
    amp = sum(filter(:));
    if(amp>=2)
        filter = filter/amp;
    end
%   fim = imfilter(im,filter,'conv');
    im_lab=rgb2lab(im);
    l = im_lab(:,:,1);
    a = im_lab(:,:,2);
    b = im_lab(:,:,3);
    fl = convn(l,filter);
    for i=1:times-1
        fl = convn(fl,filter);
    end
    fl=resize(l,fl);
    flab=cat(3, fl, a, b);
    fim=lab2rgb(flab);
    
    figure, imshow(fim), title(caption);%,print(caption,'-dpng');
    imwrite(fim,strcat(caption,'.png'),'png');
end

function cim = resize(im,fim)
    size_im=size(im);
    size_fim=size(fim);
    diff = (size_fim-size_im)/2;
    cim = fim( 1+diff(1):size_fim(1)-diff(1),1+diff(2):size_fim(2)-diff(2),:);
end