function ICV_Q4()
video = VideoReader('Dataset/DatasetC.mpg');


f1 = video.read(1);
f2 = video.read(2);

imwrite(f1, 'out/f1.png')
imwrite(f2, 'out/f2.png')

gray_1 = to_grayscale(f1);
gray_2 = to_grayscale(f2);

mv = motion_vectors(gray_1,gray_2, 16,20);


[x,y, ~] = size(mv);

fig = figure(2);
image(f2);

hold on;
quiver( mv(:,:,1), mv(:,:,2));

saveas(fig, 'out/motion_vectors' , 'png');

predfig = figure(3);

predicted = predicted_image(f1, mv);

image(predicted);

saveas(predfig, 'out/predicted','png');


% plot time for various block and window sizes.
figure(4)
title("variation of block size execution time")
b_times = zeros(3);

block_sizes = [ 4, 8, 16] 

for idx = 1:size(block_sizes)
    bs = block_sizes(idx);
    tic;
    mv = motion_vectors(gray_1,gray_2, bs,8);
    
    
    predicted_bs = predicted_image(f1,mv);
   
    t = toc;
    b_times(idx) = t;
end

plot(b_times);

figure(5);
title("variation of search window execution times");

w_times = zeros(3);
window_sizes = [ 8, 16, 32]

for idx = 1:size(window_sizes)
     ws = window_sizes(idx);
    tic
    motion_vectors(gray_1,gray_2, 4,ws);
    t = toc;
    w_times(idx) = t;
end

plot(w_times);

end