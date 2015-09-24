% consider an artificial data set of 100 variables (e.g., genes) and 10 samples
    data=rand(100,10);

% remove the mean variable-wise (row-wise)
    data=data-repmat(mean(data,2),1,size(data,2));

% calculate eigenvectors (loadings) W, and eigenvalues of the covariance matrix
    [W1, EvalueMatrix1] = eig(cov(data'));
    Evalues1 = diag(EvalueMatrix1);

% order by largest eigenvalue
    Evalues1 = Evalues1(end:-1:1);
    W1 = W1(:,end:-1:1); W1=W1';  

% generate PCA component space (PCA scores)
    pc1 = W1 * data;

% plot PCA space of the first two PCs: PC1 and PC2
    plot(pc1(1,:),pc1(2,:),'.') 