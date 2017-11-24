a=load('.\structData.mat');
b=load('.\trainData_busy2.mat');


c=MultiLayerSoftmaxClassifier(a.structData.X');
k1=hist(c,0.5:1:11.5);
k1=k1/sum(k1);

d=MultiLayerSoftmaxClassifier(b.trainData.X');
k2=hist(d,0.5:1:11.5);
k2=k2/sum(k2);

dis=sum(k1*log2(k1/k2));

