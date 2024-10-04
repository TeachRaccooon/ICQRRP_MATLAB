function[] = ICQRRP_speed_plot()
    Data_in = dlmread('../DATA_in/2024_10_re_running_all/2024_10_02_ICQRRP_GPU_speed_rows_32768_cols_32768_d_factor_1.0.txt');

    rows = 2^15; %4423
    cols = 2^15; %4423

    geqrf_tflop = (2 * rows * cols^2 - (2 / 3) * cols^3 + rows * cols + cols^2 + (14 / 3) * cols) / 10^12;
for i = 1:28
    % The input data is in microseconds, we need TFLOP/s
    Data_out(i, 1) = geqrf_tflop / (Data_in(i, 4) / 10^6); %#ok<AGROW> % ICQRRP_GPU_best
    Data_out(i, 2) = geqrf_tflop / (Data_in(i, 5) / 10^6); %#ok<AGROW> % QRF_GPU
    Data_out(i, 3) = geqrf_tflop / (Data_in(i, 6) / 10^6); %#ok<AGROW> % QRF_GPU
end
    Data_out

    %x = [32, 64, 96, 128, 160, 192, 224, 256, 288];
    x = [32, 64, 96, 128, 160, 192, 224, 256, 288, 320, 352, 384, 416, 448, 480, 512, 640, 768, 896, 1024, 1152, 1280, 1408, 1536, 1664, 1792, 1920, 2048];
    plot(x, Data_out(:, 1), '-^', 'Color', 'black', "MarkerSize", 18,'LineWidth', 1.8)
    hold on
    plot(x, Data_out(:, 2), '-*', 'Color', '#EDB120', "MarkerSize", 18,'LineWidth', 1.8)
    hold on
    plot(x, Data_out(:, 3), '-s', 'Color', 'red', "MarkerSize", 18,'LineWidth', 1.8)
    hold on
    xticks([32, 280, 512, 1024, 2048]);
    %yticks([0 200 400 600 800 1000 1200 1400 1600]);
    xlim([32 2048]);
    %ylim([0 1000]);
    ax = gca;
    ax.FontSize = 15; 
    grid on
    %ylabel('TFLOP/s', 'FontSize', 15);
    %xlabel('Block size', 'FontSize', 15); 
    lgd=legend('ICQRRP_{QRF}', 'ICQRRP_{CholQR}', 'GEQRF_{GPU}')
    lgd.FontSize = 20;
    ax = gca
    ax.XAxis.FontSize = 20;
    ax.YAxis.FontSize = 20;
%}

end