function [ output_image ] = imresize2( input_image, timesX, timesY )
% input:
%       imput_image--输入图像 uint8
%       timesX--X轴方向放缩倍数
%       timesY--Y轴方向放缩倍数
% output:
%       output_image--放缩后图像 uint8
%  by ljm 2019/9/20

[R, C] = size(input_image);
res = zeros(timesX * R, timesY * C);

for i = 1 : timesX * R
    for j = 1 : timesY * C
        x = uint8(i / timesX);
        y = uint8(j / timesY);
       if (x <= R) && (y <= C) && (x >= 1) && (y >= 1)
            res(i, j) = input_image(x, y);
        end
    end
end

output_image = uint8(res);