function ICV_Q5

video = VideoReader('Dataset/DatasetB.avi');


f1 = video.read(1);
f2 = video.read(2);
f3 = video.read(3);

imwrite(f1, 'out/ref-q5.png')
imwrite(f2, 'out/frame1-q5.png')
imwrite(f3, 'out/frme2-q5.png')

% only time to explain approach
diff1 = f2 - f1;

% always relative to the first frame (background)
diff2 = f3 -f1;


% areas of high diffs are motion

% the principle behind this algorithm is that the further the frame is 
% from the current one the more likely that the difference will be large
% (because a change of scene is more likely)
% when a change of scene occurs the difference suddenly rises 
% for a frame to be selected as a reference frame for a sequence of frames 


% counting objects 
% 2 approaches
% connect all the components and count blocks

% median filter out all noise
% count blocks bigger than certain size as object.


end