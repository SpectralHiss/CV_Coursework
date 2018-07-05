function desc = compute_window_desc(grayscale)
[h,w,~] = size(grayscale);
% looking at the divisors of the width and height of image for a frame one can choose
% 16 or 28 or 56 as window size..
window_size = int16(16);

num_h = idivide(h ,window_size);
num_w = idivide(w, window_size);

desc = zeros([num_h, num_w, 256]);
    
for window_h = 1:num_h-1
    for window_w = 1:num_w-1
        begin_h_offset = window_h * 16 +1 ;
        begin_w_offset = window_w * 16 + 1;
        
        end_h_offset = (window_h + 1) * 16 - 1;
        end_w_offset = (window_w + 1) * 16 -1;
        
        window_hist = zeros([ 1 , 256]);
        
        for i = begin_h_offset:end_h_offset
            for j = begin_w_offset:end_w_offset
                % for each pixel in window
                % we compute LBP code ON THIS PIXEL OF WINDOW
                code = 0;
                
                % needs to be counterclockwise we manually code offsets
                cc_offsets = [ [0, -1] ; [1 , -1] ; [1 , 0];  [1,1] ; [0, 1] ; [-1 , 1]; [-1,0] ; [-1, -1]];
                
                for idx = 1:size(cc_offsets,1)
                    offsets = cc_offsets(idx,:);
                    
                    ofh = offsets(1);
                    ofw = offsets(2);
                    
                    if (grayscale(i+ofh,j + ofw) > grayscale(i,j))
                        
                        % the decimal number representation is computed
                        % directly on each binary derivative
                        code = code + 2^(8-idx);
                    end
                    
                end
                
                window_hist(code + 1) = window_hist(code+1) + 1;
                
                
            end
        end
        
        desc(window_w, window_h,:) = window_hist;
        
    end
end

end