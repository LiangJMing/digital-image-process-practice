img1 = imread('tire.tif');

[img2, func_T] = myHistogramEqualization(img1);

%��ʾͼ��
figure('NumberTitle', 'off', 'Name', 'ֱ��ͼ���⻯'); 
 
subplot(2,3,1);
imshow(img1);
title('ԭʼͼ��');

subplot(2,3,2);
imshow(histeq(img1));
title('histeq()���⻯��ͼ��');
 
subplot(2,3,3);
imshow(img2);
title('���⻯��ͼ��');
 
subplot(2,3,4);
imhist(img1);
xlim([0 255]);
title('ԭʼͼ���ֱ��ͼ');
 
subplot(2,3,5);
plot(1:256,func_T);
xlim([0 255]);
ylim([0, 255]);
title('�任����');
 
subplot(2,3,6);
imhist(img2);
xlim([0 255]);
title('���⻯��ͼ���ֱ��ͼ');

function [img2, func_T] = myHistogramEqualization(img)
    img1 = double(img);
    [r, c, ] = size(img1);%��ȡͼ��ĸߺͿ�
%     ͳ��ͼ����ÿ���Ҷȼ����ֵĸ���count
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
%    ��ֱ��ͼ���⻯�ı任����
   for k = 1:256
       p_sum = p_sum + p(k);%��ÿ���Ҷȼ��ĸ���֮��
       func_T(k) = (256-1)*p_sum;%���ݱ任�����Ĺ�ʽ���
   end
   
   func_T_z = round(func_T)
   %���ÿ���ص��ӳ��
   
   for i= 1:256
       findi = find(func_T_z == i);%�ҵ��Ҷȼ�Ϊi�ĸ��ʺ�
       len = length(findi);
       for j = 1:len
           findj = find(img==(findi(j)-1));  %���ж�Ӧÿ�����ص��ӳ��
           img2(findj) = i;
       end
   end
end