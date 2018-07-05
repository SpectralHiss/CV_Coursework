function h=plot_cost2(J_1,J_2)
    h=figure('Name','cost2');
    plot(J_1,'b-')
    hold on
    plot(J_2,'r-')
    xlabel('iterations')
    ylabel('cost')
    %END OF FUNCTION

    