function ICV_Q3_histogram()
    video = VideoReader('Dataset/DatasetB.avi')
    no_figure = 1;
    
    f100 = video.read(100);
    imwrite(f100, 'out/Q3-frame-100.png');
    
    f101 = video.read(101);
    imwrite(f101, 'out/Q3-frame-101.png');
    
    f300 = video.read(300);
    imwrite(f300, 'out/Q3-frame-300.png');

    % non-consecutive frame histogram (this is manually saved through GUI)
    
    h1 = ICV_histo(f100, 'histogram of frame 100');
    ICV_histo(f300, 'histogram of frame 300');
    
    h2 = ICV_histo(f101, 'histogram of frame 101');
    
    ICV_histogram_intersect(h1,h2, 'histogram of intersection');

    function histogram = ICV_histo(img, the_title)
        
        [h,w,~] = size(img);
        
        
        histogram = uint16(zeros(256,3));
        
        for i = 1:h
            for j= 1:w
                for channel = 1:3
                    histogram(img(i,j,1)+1,channel) = histogram(img(i,j,channel)+1, channel) + 1;
                    
                end
            end
        end
        
        bin_range = [1:256];
        figure(no_figure);
        no_figure = no_figure +1;
        plot(bin_range, histogram(:,1) , 'Red' , bin_range, histogram(:,2) , 'Green', bin_range, histogram(:,3), 'Blue');
        title(the_title);

    end


    function intersection = ICV_histogram_intersect(hist1, hist2, the_title)
        
        intersection = uint16(zeros(256,3))
        
        for bin = 1:256
            for channel = 1:3
                intersection(bin,channel) = min(hist1(bin,channel),hist2(bin,channel));
            end
        end
        
        
        bin_range = [1:256]
        figure(no_figure);
        no_figure= no_figure+1;
        
        plot(bin_range, intersection(:,1) , 'Red' , bin_range, intersection(:,2) , 'Green' , bin_range, intersection(:,3), 'Blue');
        title(the_title);
    end
end