function ICV_Q2_filter(path)

% we make use of inner function to the actual filtering, this top level
% function takes the image you provide computes, displays and displays the
% output images in out/

img = imread(path);

[h,w,~] = size(img);

no_figure=2;

kernel = 1/9*[1,1,1;1,1,1;1,1,1];

kernelA = 1/16*[1,2,1;2,4,2;1,2,1]; % need to normalise
kernelB = 1/4*[0,1,0;1,-4,1;0,1,0]; % also normalised to match common laplacian operator

g5=1/264*[1,4,6,4,1;
4,16,25,16,4;
6,25,40,25,6;
4,16,25,16,4;
1,4,6,4,1];

l5 =[0.1684,0.6205,0.8425,0.6205,0.1684;
0.6205,0.5278,1.3114,0.5278,0.6205;
0.8425,1.3114,-6.8730,1.3114,0.8425;
0.6205,0.5278,1.3114,0.5278,0.6205;
0.1684,0.6205,0.8425,0.6205,0.1684];

g7=1/1035*[1,3,7,9,7,3,1;
3,12,24,31,24,12,3;
7,24,51,65,51,25,7;
9,31,65,83,65,31,9;
7,24,51,65,51,25,7;
3,12,25,31,25,12,3;
1,3,7,9,7,3,1];

l7 = [0,1,1,2,2,2,1,1,0;
    1,2,4,5,5,5,4,2,1;
    1,4,5,3,0,3,5,4,1;
    2,5,3,-12,-24,-12,3,5,2;
    2,5,0,-24,-40,-24,0,5,2;
    2,5,3,-12,-24,-12,3,5,2;
    1,4,5,3,0,3,5,4,1;
    1,2,4,5,5,5,4,2,1;
    0,1,1,2,2,2,1,1,0];

% we divide by 16
% This achieves a smoothing effect and denoising with a little blurring
%

imwrite(ICV_filter(img, kernel, 'Q2. avg filter'), 'out/Q2-avg-filter.png');

filterB_img = ICV_filter(img, kernelB, 'Q2.b filter B');

imwrite( filterB_img,'out/Q2-filterB.png');

filterA_img = ICV_filter(img, kernelA, 'Q2.b filter A');

imwrite( filterA_img,'out/Q2-filterA.png');

% this filter is not normalised we divide by 4
% this removes noise but not as much s the gaussian (on blury image it leaves some
% grainy area near the writing, with less bluring of the image

A_followed_byA = ICV_filter(filterA_img, kernelA, 'Q2.c i) A followed by A');

imwrite( A_followed_byA, 'out/Q2-A-followed-byA.png');
% smooth

A_followed_byB = ICV_filter(filterA_img, kernelB, 'Q2.c ii) A followed by B');
imwrite(A_followed_byB, 'out/Q2-A-followed-byB.png');
% best results

B_followed_ByA = ICV_filter(filterB_img, kernelA, 'Q2.c iii) B followed by A');
imwrite( B_followed_ByA , 'out/Q3-B-followed-ByA.png');

A_5x5 = ICV_filter(img, g5, 'A 5 intermediate step, (not saved)');
B_5x5 = ICV_filter(img, l5, 'B 5 intermediate step, (not saved)');

imwrite(ICV_filter(A_5x5, g5, 'Q2-d A followed by A 5x5'), 'out/Q2-dA-followed-ByA-5x5.png');
imwrite(ICV_filter(A_5x5, l5, 'Q2-d A followed by B 5x5'), 'out/Q2-dA-followed-ByB-5x5.png');

imwrite(ICV_filter(B_5x5, g5, 'Q2-d B followed by A 5x5'), 'out/Q2-dB-followed-ByA-5x5.png');

A_7x7 = ICV_filter(img, g7, 'A 7 intermediate step, (not saved)');
B_7x7 = ICV_filter(img, l7, 'B 7 intermediate step, (not saved)');

imwrite(ICV_filter(A_7x7, g7, 'Q2-d A followed by A 7x7'), 'out/Q2-dA-followed-ByA-7x7.png');
imwrite(ICV_filter(A_7x7, l7, 'Q2-d A followed by B 7x7'), 'out/Q2-dA-followed-ByB-7x7.png');

imwrite(ICV_filter(B_7x7, g7, 'Q2-d B followed by A 7x7'), 'out/Q2-dB-followed-ByA-7x7.png');


% similar, operations are commutative it seems.

    % This inner function is the meat of the operation
    function final_image = ICV_filter(img, filter,theTitle)

        [h,w,~] = size(img);

        img_new=double(zeros(h,w,1));
        % method 1 , ignore edges
        fw = size(filter,1);
        kernel_shift = fw - 1;
        
        margin = floor(fw/2)+1;
        
        for r=margin:h-margin
            for c=margin:w-margin
                for channel = 1:3
                    running_sum =0;
                    for i=(r-1:r+1)
                        for j=(c-1:c+1)
                            
                            running_sum = running_sum + double(img(i,j,channel)) * filter(i-r + kernel_shift,j-c + kernel_shift); % need to be careful in filter offsets since filter is not symmetric around origin we shift by N-1! 
            
                        end
                    end
                   
                    img_new(r,c,channel) = running_sum;
                end
            end
        end
        
        % Normalise image if negative values for LoG filter, this is by
        % computing min and max and performing normalisation
        
        final_image = uint8(zeros(h,w,1));
        for channel = 1:3
            
            low_val = min(reshape(img_new(:,:,channel).', 1, []));
            high_val = max(reshape(img_new(:,:,channel).', 1, []));
            
            for x = 4:h-4
                for y = 4:w-4
                    final_image(x,y,channel) = uint8((img_new(x,y,channel) - low_val ) * (255/ (high_val - low_val)));
                end
            end
        end
        
        figure(no_figure);
        no_figure = no_figure+1;
        imshow(final_image);
        title(theTitle);
        
    end
end

