%% Initialization
clear ; close all; clc

%% Derive principal components 
% Read the Excel file
[num,txt,raw]=xlsread('Data for assgt 2/data-assignment-2-PCA.xlsx');

% Determine the size of this data set
[n m] = size(num);

% Calculate the sample mean vector 
numMean = mean(num);

% Normalize the data 
normNum = num - repmat(numMean,[n 1]);

% Calculate eigenvectors W, and eigenvalues of the covariance matrix
[W EvalueMatrix] = eig(cov(normNum));
Evalues = diag(EvalueMatrix);

% Re-arrange the eigenvectors based on the eigenvalues
Evalues = Evalues(end:-1:1);
W = W(:,end:-1:1);
 

% Generate PCA component space (PCA scores)
pc = normNum * W;

%% The use of pca function 
[coeff, score, latent] = pca(num);

%% Plot the cumulative contribution of the PCs to the variance
varPC = cumsum(latent) / sum(latent);
plot(varPC)


