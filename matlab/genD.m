function D = genD(X)
N = size(X,1);
D = zeros(N,N); % initilize Distance matrix
onez = ones(1,N);
X = X';
XX = sum(X .* X);
for i=1:N
        % current data point
        p = X(:,i);
        % Compute Euclidean distance to all other datapoints
        D(i,:) = sum(p.^2).*onez + XX - 2*p'*X;
%         if ~isempty(find(D(:)<0))
%             'here';
%         end
end
D = abs(D).^0.5;
%D = squareform((pdist(X,'squaredeuclidean')));