function cluster = ParticleClustering(ax,X,sigma,clusterSize_min)
cluster = '';
[N,m] = size(X); % N data points in m dimensional space
D = genD(X);
deltaT = .05;
k = 0;
maxTmp_xy = 0;
onez = ones(N,1);
f=figure(1);
X_New = X;
for i = 1:N  
    tmp = deltaT*potential(D(i,:),sigma);
    tmpXY = (tmp'*ones(1,m)).*(X-onez*X(i,:));
    sumTmpXY = sum(tmpXY,1);
    X_NEW(i,:) = X(i,:)+sumTmpXY;
    maxTmp_xy = max(maxTmp_xy,norm(sumTmpXY)); % maximum displacement at first iteration   
end
deltaT = deltaT * (sigma/10) / maxTmp_xy; % make maximum displacement at first iteration 
                                          % one tenth of the specified radius 
X_New = X;
maxTemp_xy(1) = sigma/10; %maxTmp_xy;
h = waitbar(0,'Clustering in progress...');
while k <=300 || (k > 300 && maxTmp_xy > 0.1*maxTemp_xy(1) && k < 500)
    k = k + 1;
    X = X_NEW;
    waitbar(k/500,h,'Clustering in progress...');
    maxTmp_xy = 0;
    for i = 1:N
        tmp = deltaT*potential(D(i,:),sigma);
        tmpXY = (tmp'*ones(1,m)).*(X-onez*X(i,:));
        sumTmpXY = sum(tmpXY,1);
        X_NEW(i,:) = X(i,:)+sumTmpXY;
        maxTmp_xy = max(maxTmp_xy,norm(sumTmpXY));
    end
    maxTemp_xy(k) = maxTmp_xy;
    figure(f);scatter(X(:,1),X(:,2),31);drawnow;
    D = genD(X);
end
close(h);
clusterNum = 0;
clusterIdx_record = [];
for i = 1:N
    [tmp,clusterIdx] = find(D(i,:) <= sigma*3);
    if sum(tmp) >= clusterSize_min && isValidIdx(clusterIdx_record,clusterIdx)
        clusterIdx_record{end+1} = clusterIdx;
        clusterNum = clusterNum + 1;
        cluster{clusterNum}.center = mean(X(clusterIdx,:),1);
        cluster{clusterNum}.size = sum(tmp);
        cluster{clusterNum}.idx = clusterIdx;
    end
end
'h';
%figure(5);plot(maxTemp_xy);

function yesNo = isValidIdx(clusterIdx_record,clusterIdx)
yesNo = true;
if isempty(clusterIdx_record)
    return
end
numOfRecord = length(clusterIdx_record);
for i = 1:numOfRecord
    if length(clusterIdx_record{i}) == length(clusterIdx) ...
            &&  sum(clusterIdx_record{i} == clusterIdx) == length(clusterIdx) 
        yesNo = false;
        break
    end
end
return
