function[] = ICQRRP_speed_plot()
    Data_in = dlmread('../DATA_in/2024_09_re_running_all/20224_09_14_Hexane_ICQRRP_GPU_speed_rows_16384_cols_16384_d_factor_1.txt');

    rows = 2^14; %4423
    cols = 2^14; %4423

    geqrf_gflop = (2 * rows * cols^2 - (2 / 3) * cols^3 + rows * cols + cols^2 + (14 / 3) * cols) / 10^9;
for i = 1:28
    Data_out(i, 1) = geqrf_gflop / (Data_in(i, 4) / 10^3); %#ok<AGROW> % ICQRRP_GPU_best
    Data_out(i, 2) = geqrf_gflop / (Data_in(i, 5) / 10^3); %#ok<AGROW> % QRF_GPU
    Data_out(i, 3) = geqrf_gflop / (Data_in(i, 6) / 10^3); %#ok<AGROW> % QRF_GPU
end
    Data_out

    %x = [32, 64, 96, 128, 160, 192, 224, 256, 288];
    x = [32, 64, 96, 128, 160, 192, 224, 256, 288, 320, 352, 384, 416, 448, 480, 512, 640, 768, 896, 1024, 1152, 1280, 1408, 1536, 1664, 1792, 1920, 2048];
    plot(x, Data_out(:, 1), '-^', 'Color', 'black', "MarkerSize", 18,'LineWidth', 1.8)
    hold on
    plot(x, Data_out(:, 2), '-*', 'Color', 'blue', "MarkerSize", 18,'LineWidth', 1.8)
    hold on
    plot(x, Data_out(:, 3), '-s', 'Color', 'red', "MarkerSize", 18,'LineWidth', 1.8)
    hold on
    xticks([32, 280, 512, 1024, 2048]);
    %yticks([0 200 400 600 800 1000 1200 1400 1600]);
    xlim([32 192]);
    %ylim([0 1000]);
    ax = gca;
    ax.FontSize = 15; 
    grid on
    ylabel('GFLOP/s', 'FontSize', 15);
    xlabel('Block size', 'FontSize', 15); 
    lgd=legend('ICQRRP_{QRF}', 'ICQRRP_{CholQR}', 'GEQRF_{GPU}')
    lgd.FontSize = 20;
    ax = gca
    ax.XAxis.FontSize = 20;
    ax.YAxis.FontSize = 20;
%}

end