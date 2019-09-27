function [ output_image ] = imrotate2( input_image, degree )
%imrotate2 实现图像绕中心点旋转
%input：
%       input_image 输入图像 uint8
%       degree 旋转角度，逆时针，单位 °
% output:
%       output_image 旋转后图像 uint8
% BY LJM 2019/9/20

[R, C] = size(input_image);
radian = degree * pi / 180;
hight = C*abs(cos(radian)) + R* abs(sin(radian));
width = C*abs(sin(radian)) + R* abs(cos(radian));

res = zeros(round(hight), round(width));

T = [cos(radian) -sin(radian) 0; sin(radian) cos(radian) 0; 0 0 1];

for i = 1 : hight
    for j = 1 : width
        temp = [i-hight/2; j-width/2; 1];
        temp = T * temp;
        x = uint16(temp(1, 1)+R/2);
        y = uint16(temp(2, 1)+C/2);
       if (x <= R) && (y <= C) && (x >= 1) && (y >= 1)
            res(i, j) = input_image(x, y);
        end
    end
end

output_image = uint8(res);

