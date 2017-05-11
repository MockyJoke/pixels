close all
clc
clear
% read image
% im_t = imread('PA2-testimages/template_bear.png');
% im = imread('PA2-testimages/animals.jpg');

im_t = imread('PA2-testimages/template_Q.png');
im = imread('PA2-testimages/letters.png');

% im_t = imread('PA2-testimages/block.tif');
% im = imread('PA2-testimages/block3.tif');
% showIm(im_t,'template');
rTable = buildRTable(rgb2gray(im_t));

% fim_canny = edge(im,'Canny');
%  [Gmag,Gdir] = imgradient(im,'intermediate');
% 
% figure; imshowpair(Gmag, Gdir, 'montage');
% title('Gradient Magnitude, Gmag (left), and Gradient Direction, Gdir (right), using Prewitt method')
% axis off;
% showIm(fim_canny,'canny-smooth')
% 

printRTable(rTable);
% printRTable(buildRTable(im));
[maxResult,maxAccuArray]=cMatch(rgb2gray(im),rTable);
%  circle(im,maxResult(1),maxResult(2),28);

  mMatch(im,rTable)

function matchResults=mMatch(im,rTable)
    scales=[1];
    %     scales=linspace(1,1.4,6);
    %     rotations=[0];
    rotations=linspace(-10,8,9);
    matches={};
    numof_matches=0;
    [match,accuArray] = GHTMatch2(rgb2gray(im),rTable,scales(1),0);
   
    h=[];
    
    for r=1:size(rotations,2)
        [match,accuArray] = GHTMatch2(rgb2gray(im),rTable,scales(1),rotations(r));
        numof_matches=numof_matches+1;
        matches{numof_matches}=match;
    end
    imshow(im);
    for i=1:numof_matches
        h=circleNoSave(im,matches{i}(1),matches{i}(2),28);
    end
    saveas(h,sprintf('match.png'))
    
    
end
function [maxResult,maxAccuArray]=cMatch(im,rTable)
      scales=[1];
%      scales=linspace(1,1.4,6);
    rotations=[0];
%     rotations=linspace(0,360,20);
    maxVotes=0;
    maxResult=[];
    
    maxAccuArray=[];
    for s=1:size(scales,2)
        for r=1:size(rotations,2)
            [match,accuArray] = GHTMatch2(im,rTable,scales(s),rotations(r));

%             imshow(accuArray/255);
            if(size(match,2)~=0)&&(match(3)>maxVotes)
                maxResult=match;
                maxAccuArray=accuArray;
                maxVotes=match(3);
            end
        end
    end
    showIm(imadjust(maxAccuArray/255),'aa');
end

function [maxIndex,maxAccuArray] = GHTMatch2(im,rTable,scale,rotate)
%      im=rgb2gray(im);
    fim_canny = edge(im,'Canny');
    showIm(fim_canny,'Canny')
    [Gmag,Gdir] = imgradient(im);
    im_bin = imbinarize(Gmag);
    [y, x]=find(fim_canny>0);
    numof_edgePts=size(x,1);
    accuArray=zeros(size(im));
    
    for i=1:numof_edgePts
        pt_x=x(i);
        pt_y=y(i);
        gradient = Gdir(pt_y,pt_x);
        
        gradient=mod(gradient+360-rotate,360); 
        
%         gradient=round(gradient);
        box_index=floor(gradient/10+1);
%           fprintf('%d,%d,%d\n ',gradient,rotate,box_index);
        numof_entries=size(rTable{box_index},2);
        if(numof_entries~=0)
            for j=1:numof_entries
                v=rTable{box_index}{j};
                distance = v(1);
                phi = v(2);
                c_x=round(pt_x+distance*scale*cosd(phi-rotate));
                c_y=round(pt_y+distance*scale*sind(phi-rotate));
                if(isInRange(im,c_x,c_y))
%                      fprintf('%d,%d\n ',c_x,c_y);
                    accuArray(c_y,c_x)=accuArray(c_y,c_x)+1;
                end
            end
%             fprintf('\n');
        end
    end
    maxValue=accuArray(1,1);
    maxIndex=[];
    maxAccuArray=[];
    for y=1:size(im,1)
        for x=1:size(im,2)
            votes = accuArray(y,x);
            if(votes>maxValue)
                maxIndex=[x,y,votes];
                maxAccuArray=accuArray;
                maxValue=votes;
            end
        end
    end
end
% function maxIndex = GHTMatch(im,rTable)
% %      im=rgb2gray(im);
% %     fim_canny = edge(im,'Canny');
%     [Gmag,Gdir] = imgradient(im,'intermediate');
%     im_bin = imbinarize(Gmag);
%     [y, x]=find(im_bin>0);
%     numof_edgePts=size(x);
%     accuArray=zeros(size(im));
%     
%     for i=1:numof_edgePts
%         pt_x=x(i);
%         pt_y=y(i);
%         gradient = Gdir(pt_y,pt_x);
%         if(gradient<0)
%            gradient=gradient+360; 
%         end
%         box_index=round(gradient+1);
%         numof_entries=size(rTable{box_index},2);
%         if(numof_entries~=0)
%             for j=1:numof_entries
%                 v=rTable{box_index}{j};
%                 distance = v(1);
%                 phi = v(2);
%                 c_x=round(pt_x+distance*cosd(phi));
%                 c_y=round(pt_y+distance*sind(phi));
%                 if(isInRange(im,c_x,c_y))
% %                     fprintf('%d,%d\n ',c_x,c_y);
%                     accuArray(c_y,c_x)=accuArray(c_y,c_x)+1;
%                 end
%             end
% %             fprintf('\n');
%         end
%     end
%     maxValue=accuArray(1,1);
%     maxIndex=[];
%     for y=1:size(im,1)
%         for x=1:size(im,2)
%             votes = accuArray(y,x);
%             if(votes>maxValue)
%                 maxIndex=[x,y,votes];
%                 maxValue=votes;
%             end
%         end
%     end
% end
function result=isInRange(im,x,y)
    result=false;
    x_min=1;
    x_max=size(im,2);
    y_min=1;
    y_max=size(im,1);
    if(x>=x_min)&&(x<=x_max)&&(y>=y_min)&&(y<=y_max)
        result=true;
    end
end

function rTable = buildRTable(im)
%     im=rgb2gray(im);
    fim_canny = edge(im,'Canny');
    showIm(fim_canny,'template_canny')
    [Gmag,Gdir] = imgradient(im);
    
    im_bin = imbinarize(Gmag);
    [y, x]=find(fim_canny>0);
    ref_y= round(mean(y));
    ref_x= round(mean(x));
    numof_edgePts=size(x,1);
    numof_boxes=36;
%     sample=zeros(size(im));
%     rTable= zeros(numof_boxes,numof_edgePts(1),2);
    rTable= {numof_boxes};
    for i=1:numof_boxes
        rTable{i}={};
    end
    entryCounter= zeros(numof_boxes,1);
    for i=1:numof_edgePts
        pt_x=x(i);
        pt_y=y(i);
        distance = pdist([pt_x,pt_y;ref_x,ref_y],'euclidean');
        rise = ref_y - pt_y;
        run = ref_x - pt_x;
%         vector=[run,rise];
        phi = atan2d(rise,run);
%         if(phi<0)
%             phi=mod(phi+360,360); 
%         end
%         phi=round(phi);
        sample(pt_y,pt_x)=phi;
        
        gradient = Gdir(pt_y,pt_x);
        
        gradient=mod(gradient+360,360); 
        
        box_index=floor(gradient/10 + 1);
        entry = [distance,phi];
%          X = sprintf('(%d,%d) -> (%d,%d) %f \n',pt_x,pt_y,run,rise,gradient);
%           disp(X);
        entryCounter(box_index)=entryCounter(box_index)+1;
%        
        rTable{box_index}{entryCounter(box_index)}=entry;
    end
    
end

function printRTable(rTable)
    numof_boxes=size(rTable,2);
    for i=1:numof_boxes
        numof_entries=size(rTable{i},2);
        if(numof_entries~=0)
            fprintf('%d(%d): ',i,numof_entries);
           	for j=1:numof_entries
                fprintf('%f,%f ',rTable{i}{j}(1),rTable{i}{j}(2));
            end
            fprintf('\n');
        end
    end
end
function h=circle(im,x,y,r)
    %e
    %r= desired radius
    %x = x coordinates of the centroid
    %y = y coordinates of the centroid
    th = 0:pi/50:2*pi;
    xunit = r * cos(th) + x;
    yunit = r * sin(th) + y;
    imshow(im)
    hold on;
    plot(xunit, yunit,'r');
    xunit = (r+1) * cos(th) + x;
    yunit = (r+1) * sin(th) + y;
    h = plot(xunit, yunit,'r');
    saveas(h,sprintf('match.png'))
end
function h=circleNoSave(im,x,y,r)
    %e
    %r= desired radius
    %x = x coordinates of the centroid
    %y = y coordinates of the centroid
    th = 0:pi/50:2*pi;
    xunit = r * cos(th) + x;
    yunit = r * sin(th) + y;
    hold on;
    plot(xunit, yunit,'r');
    xunit = (r+1) * cos(th) + x;
    yunit = (r+1) * sin(th) + y;
    hold on;
    h = plot(xunit, yunit,'r');
end
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