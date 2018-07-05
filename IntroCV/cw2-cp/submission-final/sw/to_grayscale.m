
    function gray_img = to_grayscale(img)
        [h,w,~] = size(img);
        gray_img = uint8(zeros(h,w));
        for i = 1:h
            for j = 1:w
                gray_img(i,j) = sum(img(i,j,:)) / 3;
            end
        end
    end