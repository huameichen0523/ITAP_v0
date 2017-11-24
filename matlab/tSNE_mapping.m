%DEMO Demonstration of parametric t-SNE

function[]=tSNE_mapping()

% load data
b= load('.\working\structData.mat');

test_X=(b.structData.X);
test_labels = b.structData.Y;
 
% load model
c= load('.\input\Pre-generated\Model_ParaTSNE_Trajectory30.mat');

% run network
mapped_test_X  = run_data_through_network(c.network, test_X);
% save result
save .\working\mapped_test_X.mat mapped_test_X;
%     save train_labels_fast.mat train_labels;
save .\working\test_labels.mat test_labels;

end

