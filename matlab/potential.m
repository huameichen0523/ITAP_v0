function p = potential(r,sigma)

p = exp(-(r.^2)/(sigma^2))*2.*r/sigma^2;
p(r > 3*sigma) = 0;

return
