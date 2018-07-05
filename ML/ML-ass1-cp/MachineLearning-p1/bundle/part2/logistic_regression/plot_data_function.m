function h= plot_data_function(x,y,title)
    
    if nargin < 3
        h=figure('Name','data');
    else
        h=figure('Name',title);
    end
    hold on
    for i =1:length(x)
        if y(i) < 1
            d = 'rx';
        else
            d = 'bo';
        end
        plot(x(i,2),x(i,3),d)
        
    end
    xlabel('x1')
    ylabel('x2')
   
    %END OF FUNCTION

    