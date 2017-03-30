% Number of class
K = 2;

feature_vec = [sensor_sim_out_normal'; sensor_sim_out_fault'];

normal(1:length(sensor_sim_out_normal'), 1) = 1;
fault(1:length(sensor_sim_out_fault'), 1) = 2;
output_vec = [normal;fault];

X = feature_vec;

% Subtract the mean to use PCA
[X_norm, mu, sigma] = featureNormalize(X);

% PCA and project the data to 2D
[U, S] = pca(X_norm);
Z = projectData(X_norm, U, 2);

%  Setup Color Palette
palette = hsv(K);
colors = palette(output_vec, :);

scatter(Z(:,1), Z(:,2),15,colors)