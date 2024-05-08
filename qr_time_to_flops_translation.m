function[] = qr_time_to_flops_translation()
    Data_in = dlmread('DATA_in/QR_time_raw_rows_65536_cols_65536_b_sz_start_256_b_sz_end_2048_d_factor_1.250000.txt');

    rows = 2^16;
    cols = 2^16;

    geqrf_gflop = (2 * rows * cols^2 - (2 / 3) * cols^3 + rows * cols + cols^2 + (14 / 3) * cols) / 10^9;

    Data_out = [];
    for i = 1:size(Data_in, 1)
        Data_out(i, 1) = geqrf_gflop / (Data_in(i, 1) / 10^6);  %#ok<AGROW> % ICQRRP
        Data_out(i, 2) = geqrf_gflop / (Data_in(i, 2) / 10^6); %#ok<AGROW> % HQRRP GEQRF
        %Data_out(i, 3) = geqrf_gflop / (Data_in(i, 3) / 10^6); %#ok<AGROW> % HQRRP CholQR
        %Data_out(i, 2) = geqrf_gflop / (Data_in(i, 4) / 10^6); %#ok<AGROW>  % GEQRF
        %Data_out(i, 3) = geqrf_gflop / (Data_in(i, 5) / 10^6); %#ok<AGROW>  % GEQP3
        %Data_out(i, 4) = geqrf_gflop / (Data_in(i, 6) / 10^6); %#ok<AGROW>  % ICQRRP GEQP3
        %Data_out(i, 5) = geqrf_gflop / (Data_in(i, 7) / 10^6); %#ok<AGROW>  % HQRRP
        %Data_in(i, 7)
    end
    Data_out

    x = [256 512 1024 2048];
    plot(x, Data_out(:, 1), '-^', 'Color', 'black', "MarkerSize", 10,'LineWidth', 1.2)
    hold on
    plot(x, Data_out(:, 2), '-o', 'Color', 'red', "MarkerSize", 10,'LineWidth', 1.2)
    hold on
    %plot(x, Data_out(:, 3), '-diamond', 'Color', 'blue', "MarkerSize", 10,'LineWidth', 1.2)
    %hold on
    %plot(x, Data_out(:, 4), '-^', 'Color', '#EDB120', "MarkerSize", 10,'LineWidth', 1.2)
    %hold on
    %plot(x, Data_out(:, 5), '-s', 'Color', 'magenta', "MarkerSize", 10,'LineWidth', 1.2)
    xticks([256 512 1024 2048]);
    xlim([256 2048]);
    ylim([0 1600]);
    ax = gca;
    ax.FontSize = 15; 
    grid on
    %ylabel('GFLOP/s', 'FontSize', 15);
    %xlabel('Block size', 'FontSize', 15); 
    legend('ICQRRP', 'GEQRF', 'GEQP3', 'ICQRRP\_QP3', 'HQRRP')

    %saveas(gcf,'DATA_out/24_threads_QR_time_raw_rows_16384_cols_16384_b_sz_start_256_b_sz_end_2048_d_factor_1.250000.png')
end


