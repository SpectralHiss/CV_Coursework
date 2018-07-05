function ICV_compute_kernels(stddev)
    precision = 1000;
     
    g5 = (discrete_integrate(compute_gaussian(stddev), 5));
    % finally we scale such as corner point is 1 and cast to integer
    % for gaussians the convention seems to set the corner of the filter to
    % 1
    g5 = round(g5/ g5(1,1))
     sum(reshape(g5.' , 1 , []))
    
    l5 = discrete_integrate(compute_laplacian_operator(stddev), 5)
    l5 = -l5 / sum(reshape(l5.' , 1 , []))
    
    g7 = discrete_integrate(compute_gaussian(stddev), 7);
    % finally we scale such as corner point is 1 and cast to integer
    g7 = round(g7/ g7(1,1))
    sum(reshape(g7.' , 1 , []))
    
    l7 = discrete_integrate(compute_laplacian_operator(stddev), 7)
    l7 = -l7 / sum(reshape(l7.' , 1 , []))
    
    function gaussian = compute_gaussian(stddev)
        
        range = 2.5;
        x=linspace(-stddev*range,stddev*range,precision);
        y=x';
        [X,Y] = meshgrid(x,y);
        gaussian=1/(sqrt(2* pi) *  stddev) .* exp(-(x.^2 + y.^2)/ ( 2 .* stddev^2));
        % uncomment for cool visualisation of function
        %surf(x,y,gaussian); shading interp
    end

    function laplacian = compute_laplacian_operator(stddev)
      
        range = 3;
        x=linspace(-stddev*range,stddev*range,precision);
        y=x';
        [X,Y] = meshgrid(x,y);
        laplacian=-1/(pi * stddev^4) * ( 1 - ((x .^2 + y .^ 2)/ ( 2 * stddev^2))) .* exp(-(x.^2 + y.^2)/ (2* stddev^2));
        % uncomment for cool visualisation
        surf(x,y,laplacian); shading interp
    end

    % this is the naive rectangular box integration which may result in
    % inaccuracy
    function kernel = discrete_integrate(funcdata,kernel_size)
        kernel = double(zeros(kernel_size,kernel_size));
        for boxi = 1:(kernel_size)
            for boxj = 1:(kernel_size)
                width = (stddev/precision);
                slice = precision/(kernel_size);
                integrand_range = funcdata((boxi-1)*slice+1:boxi*slice, (boxj-1) * slice + 1:boxj * slice);
                kernel(boxi, boxj) = sum(reshape(integrand_range.' , 1 , [])) * width^2;
                
            end
        end
        
        
    end
end