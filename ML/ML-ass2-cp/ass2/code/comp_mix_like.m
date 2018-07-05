%% helper method for likelihood under gmm
    function likelihood = comp_mix_like(x,m)
         [ ~ , k ] = size(m.mu);
         mu = m.mu;
         s2 = m.s2;
         p = m.p;
        [n D] = size(x);
        
        likelihood =0;
        for i = 1:k
            likelihood = likelihood + p(i)*det(s2(:,:,i))^(-0.5)*exp(-0.5*sum((x'-repmat(mu(:,i),1,n))'*inv(s2(:,:,i)).*(x'-repmat(mu(:,i),1,n))',2));
        end
    end