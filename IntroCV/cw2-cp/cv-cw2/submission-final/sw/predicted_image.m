function pred_img = predicted_image(img, mv)
    [h,w, c ] = size(img)
    pred_img = img;
    
    for i = 1:h
        for j = 1:w
            dest = mv(i,j) + [i,j]
            if dest(1) > 1 && dest(1) < h && dest(2) > 1 && dest(2) < w
                pred_img(dest(1),dest(2),1) = img(i,j,1);
                pred_img(dest(1),dest(2),2) = img(i,j,2);
                pred_img(dest(1),dest(2),3) = img(i,j,3);
            end
        end
    end
   
end