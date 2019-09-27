img1 = imread('tire.tif');

[img2, func_T] = myHistogramEqualization(img1);

%显示图像
figure('NumberTitle', 'off', 'Name', '直方图均衡化'); 
 
subplot(2,3,1);
imshow(img1);
title('原始图像');

subplot(2,3,2);
imshow(histeq(img1));
title('histeq()均衡化后图像');
 
subplot(2,3,3);
imshow(img2);
title('均衡化后图像');
 
subplot(2,3,4);
imhist(img1);
xlim([0 255]);
title('原始图像的直方图');
 
subplot(2,3,5);
plot(1:256,func_T);
xlim([0 255]);
ylim([0, 255]);
title('变换函数');
 
subplot(2,3,6);
imhist(img2);
xlim([0 255]);
title('均衡化后图像的直方图');

function [img2, func_T] = myHistogramEqualization(img)
    img1 = double(img);
    [r, c, ] = size(img1);%获取图像的高和宽
%     统计图像中每个灰度级出现的概率count
    count = zeros(1, 256);
    for i = 1:r
        for j = 1:c
            count(1, img(i, j)+1) = count(1, img(i,j)+1)+1;
        end
    end
    
   p = zeros(1, 256);
   for i= 1:256
       p(1, i) = count(1, i)/(r*c);
   end
   
   img2 = im2uint8(ones(r, c));
   func_T = zeros(1, 256);
   p_sum = 0;
%    求直方图均衡化的变换函数
   for k = 1:256
       p_sum = p_sum + p(k);%求每个灰度级的概率之和
       func_T(k) = (256-1)*p_sum;%根据变换函数的公式求和
   end
   
   func_T_z = round(func_T)
   %完成每像素点的映射
   
   for i= 1:256
       findi = find(func_T_z == i);%找到灰度级为i的概率和
       len = length(findi);
       for j = 1:len
           findj = find(img==(findi(j)-1));  %进行对应每个像素点的映射
           img2(findj) = i;
       end
   end
end