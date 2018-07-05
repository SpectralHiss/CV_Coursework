function mv = motion_vectors(f1,f2, bs, ws)
% matching blocks in frame 2 with frame 1 for obtaining motion vectors
% bs and ws are block size and window size respectively, bs of 16 -> 16 x
% 16 blocks

[h,w,~] = size(f1);
[h2,w2,~] = size(f2);

if h ~= h2 || w2 ~= w2 
    error("frames must be of same size")
end

mv = zeros(h,w,2) 

for tbh = (1:h)
    for tbw = (1:w)

        min_sum = Inf;
        % for each target block in current frame 
        
        for cwh = (-ws/2:ws/2) 
            for cww = (-ws/2:ws/2)
               
                %compared to each block with window centered around val
                block_base_h = tbh + cwh;
                block_base_w = tbw + cww;
                
                if block_base_w < 1 || block_base_w > w || block_base_h < 1 || block_base_h > h
                    continue
                end
                
                % using Mean Absolute Error
                SAE = 0;
                
                for ph = 1:bs
                    for pw = 1:bs
                        block_search_h = block_base_h + ph;
                        block_search_w = block_base_w + pw;
                        
                        target_search_h = tbh + ph;
                        target_search_w = tbw + pw;
                        
                      
                        
                        if target_search_w < 1 || target_search_w > w || block_search_w > w || target_search_h > h || block_search_h < 1 || block_search_h > h
                            continue
                        end
                        
                        SAE = abs(f2( block_search_h,block_search_w ) - f1( target_search_h , target_search_w));
                    end
                end
                
                if SAE < min_sum
                    % set position to center of block (so far we use the
                    % top left corner)
                    mv(tbh + bs /2, tbw + bs / 2,:) = [ cwh  , cww ];
                    min_sum = SAE;
                end
                
            end
       end
                
        
    end
end


end