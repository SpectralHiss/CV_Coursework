function ICV_Q6 

video = VideoReader('Dataset/DatasetB.avi');

f1 = video.read(1);



gray_f1 = to_grayscale(f1);

% this structure is a matrix of histograms for each window
window_desc = compute_window_desc(gray_f1);

% element by element merge of histograms
global_histogram = sum(window_desc);



% make scale space 2x 10x zoomed images


% run histogram similarity 



end