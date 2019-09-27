
origin = imread('tire.tif');
[m_o, n_o] = size(origin);
origin_hist = imhist(origin)/(m_o*n_o);

standard = imread('cameraman.tif');
[m_s, n_s] = size(standard);
standard_hist = imhist(standard)/(m_s*n_s);

standard_value = [];
origin_value = [];

for i = 1:256
    standard_value = [standard_value sum(standard_hist(1:i))];
    origin_value = [origin_value sum(origin_hist(1:i))];
end

for i = 1:256
    value{i} = standard_value-origin_value(i);
    value{i} = abs(value{i});
    [temp index(i)] = min(value{i});
end

newimg = zeros(m_o, n_o);
for i = 1:m_o
    for j = 1:n_o
        newimg(i, j) = index(origin(i,j)+1)-1;
    end
end

newimg = uint8(newimg);
subplot(2,3,1);imshow(origin);title('原图');
subplot(2,3,2);imshow(standard);title('标准图');
subplot(2,3,3);imshow(newimg);title('myself匹配到标准图');
subplot(2,3,4);imhist(origin);
title('原图');
subplot(2,3,5);imhist(standard);
title('标准图');
subplot(2,3,6);imhist(newimg);
title('myself匹配到标准图');

