function ER = log_gauss(x,mu,sigma,k)
    P = zeros(k,length(x));
    for i=1:k
        P(i,:) = normpdf(x,mu(i),sigma(i));
    end
    ER = -1*log(P+eps);
end