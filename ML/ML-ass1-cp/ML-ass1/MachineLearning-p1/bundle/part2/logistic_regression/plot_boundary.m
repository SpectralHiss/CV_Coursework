function plot_boundary(x,theta)
   
    hold on
    max_x1 = max(x(:,2))+1;
    min_x1 = min(x(:,2))-1;
    max_x2 = max(x(:,3));
    min_x2 = min(x(:,3));
    % modify this:
    y1 = -(theta(1) * min_x1 / theta(2));
    % modify this:
    y2 = -(theta(1) * max_x1 / theta(2));
    
    
    plot([min_x1,max_x1],[y1,y2],'-')
    xlabel('x1')
    ylabel('x2')
    
    %END OF FUNCTION