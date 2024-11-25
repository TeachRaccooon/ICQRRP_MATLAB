figure;

QRF_arr = [1593, 1593, 1593, 1593];
ICQRRP_LU = [679, 928, 1010, 973];
ICQRRP_QP3 = [510, 500, 480, 410];
HQRRP = [400, 250, 170, 90]; 
QP3 = [20, 20, 20, 20]; 

subplot(1, 2, 1); 
x = [256, 512, 1024, 2048];
plot(x, QRF_arr, '-^', 'Color', 'red', "MarkerSize", 18,'LineWidth', 1.8)
hold on
plot(x, ICQRRP_LU, '-*', 'Color', 'black', "MarkerSize", 18,'LineWidth', 1.8)
hold on
plot(x, ICQRRP_QP3, '-o', 'Color', '#EDB120', "MarkerSize", 18,'LineWidth', 1.8)
hold on
plot(x, HQRRP, '-s', 'Color', 'magenta', "MarkerSize", 18,'LineWidth', 1.8)
hold on
plot(x, QP3, '->', 'Color', 'blue', "MarkerSize", 18,'LineWidth', 1.8)

xticks([256 512 1024 2048]);
xlim([256 2048]);
ylim([0 2500]);
ax = gca;
ax.FontSize = 15; 
grid on
title('CPU Performance')
ylabel('GFLOP/s', 'FontSize', 15);
xlabel('Block size', 'FontSize', 15); 
lgd=legend('UNPIVOTED QR', 'OUR QRCP', 'OUR QRCP SLOW', 'RIVAL QRCP', 'STANDARD QRCP')
lgd.FontSize = 20;
ax = gca
ax.XAxis.FontSize = 25;
ax.YAxis.FontSize = 25;

Data_in = dlmread('32k_gpu.txt');
rows = 2^14;
cols = 2^14;

geqrf_gflop = (2 * rows * cols^2 - (2 / 3) * cols^3 + rows * cols + cols^2 + (14 / 3) * cols) / 10^9;
for i = 1:28
    Data_out(i, 1) = geqrf_gflop / (Data_in(i, 4) / 10^3); %#ok<AGROW> % ICQRRP_GPU_best
    Data_out(i, 2) = geqrf_gflop / (Data_in(i, 5) / 10^3); %#ok<AGROW> % QRF_GPU
    Data_out(i, 3) = geqrf_gflop / (Data_in(i, 6) / 10^3); %#ok<AGROW> % QRF_GPU
end

subplot(1, 2, 2); 
x = [32, 64, 96, 128, 160, 192, 224, 256, 288, 320, 352, 384, 416, 448, 480, 512, 640, 768, 896, 1024, 1152, 1280, 1408, 1536, 1664, 1792, 1920, 2048];
plot(x, Data_out(:, 3), '-^', 'Color', 'red', "MarkerSize", 18,'LineWidth', 1.8)
hold on 
plot(x, Data_out(:, 1), '-*', 'Color', 'black', "MarkerSize", 18,'LineWidth', 1.8)
hold on
plot(x, Data_out(:, 2), '-*', 'Color', 'cyan', "MarkerSize", 18,'LineWidth', 1.8)
hold on
xticks([32, 280, 512, 1024, 2048]);
xlim([32 2048]);
ax = gca;
ax.FontSize = 15; 
grid on
title('GPU Performance')
xlabel('Block size', 'FontSize', 15); 
lgd=legend('UNPIVOTED QRF', 'OUR QRCP + QRF PANEL', 'OUR QRCP + CholQR PANEL')
lgd.FontSize = 20;
ax = gca
ax.XAxis.FontSize = 25;
ax.YAxis.FontSize = 25;




