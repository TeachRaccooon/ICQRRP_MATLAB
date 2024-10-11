% Create a figure
figure;

% Plot the first figure in the first subplot
subplot(1, 2, 1); % 1 row, 2 columns, first plot
plot(rand(1, 10), 'r', 'DisplayName', 'Data 1');
hold on;
plot(rand(1, 10), 'g', 'DisplayName', 'Data 2');
title('First Plot');

% Plot the second figure in the second subplot
subplot(1, 2, 2); % 1 row, 2 columns, second plot
plot(rand(1, 10), 'b', 'DisplayName', 'Data 3');
hold on;
plot(rand(1, 10), 'k', 'DisplayName', 'Data 4');
title('Second Plot');

% Create a common legend for both subplots
legend({'Data 1', 'Data 2', 'Data 3', 'Data 4'}, 'Position', [0.5, 0.05, 0, 0], 'Orientation', 'horizontal');