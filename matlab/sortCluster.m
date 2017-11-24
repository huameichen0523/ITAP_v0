function [ idx ] = sortCluster(C )

n = length(C);
C_size = zeros(1,n);
for i = 1:n
    C_size(i) = C{i}.size;
end
[~,idx] = sort(C_size,'descend');

end

