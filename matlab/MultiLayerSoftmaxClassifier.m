function [ output_class ] = MultiLayerSoftmaxClassifier( varargin )
% use pre-trained multi-layer softmax classifier to classify trajectory
% patterns
%
% The first input is data matrix and the second input, if present, should
% be the pre-trained network
%
% 
X = varargin{1};
if nargin == 2
    network = varargin{2};
else
    load('.\input\Pre-generated\Model_TrajectoryClassification_multiLayerSoftmax.mat');
end
if size(X,2) == size(network{1}.W,1)
    pred = (run_data_through_network(network, X));
else
    pred = (run_data_through_network(network, X'));
   
end
 [~,output_class] = max(pred,[],2);
end
    

