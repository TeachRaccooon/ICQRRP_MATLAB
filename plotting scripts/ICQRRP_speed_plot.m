function[] = ICQRRP_speed_plot()
    %Data_in = dlmread('../DATA_in/2024_10_re_running_all/2024_10_06_EPYC-9354P/OpenMP32/ICQRRP_time_raw_rows_16384_cols_16384_b_sz_start_256_b_sz_end_1024_d_factor_1.000000.dat');
    Data_in = dlmread('../DATA_in/2024_10_re_running_all/I2024_10_10_CQRRP_time_raw_rows_65536_cols_65536_b_sz_start_256_b_sz_end_2048_d_factor_1.000000.txt');


    rows = 2^16;
    cols = 2^16;

    Data_in = data_preprocessing_best(Data_in, 4, 3)

    geqrf_gflop = (2 * rows * cols^2 - (2 / 3) * cols^3 + rows * cols + cols^2 + (14 / 3) * cols) / 10^9;
for i = 1:4
    Data_out(i, 1) = geqrf_gflop / (Data_in(i, 1) / 10^6); %#ok<AGROW> % ICQRRP_best
    Data_out(i, 2) = geqrf_gflop / (Data_in(i, 2) / 10^6); %#ok<AGROW> % ICQRRP_QP3
    Data_out(i, 3) = geqrf_gflop / (Data_in(i, 3) / 10^6); %#ok<AGROW  % HQRRP
    Data_out(i, 4) = geqrf_gflop / (Data_in(i, 4) / 10^6); %#ok<AGROW> % HQRRP_GEQRF
    Data_out(i, 5) = geqrf_gflop / (Data_in(i, 5) / 10^6); %#ok<AGROW> % HQRRP_CholQR
    Data_out(i, 6) = geqrf_gflop / (Data_in(i, 6) / 10^6); %#ok<AGROW> % GEQRF
    Data_out(i, 7) = geqrf_gflop / (Data_in(i, 7) / 10^6); %#ok<AGROW> % GEQP3
end
    Data_out

    x = [256 512 1024 2048];
    semilogx(x, Data_out(:, 1), '-^', 'Color', 'black', "MarkerSize", 18,'LineWidth', 1.8)
    hold on
    semilogx(x, Data_out(:, 2), '-*', 'Color', 'blue', "MarkerSize", 18,'LineWidth', 1.8)
    hold on
    semilogx(x, Data_out(:, 3), '-o', 'Color', 'red', "MarkerSize", 18,'LineWidth', 1.8)
    hold on
    semilogx(x, Data_out(:, 4), '-s', 'Color', '#00FFFF', "MarkerSize", 18,'LineWidth', 1.8)
    hold on
    semilogx(x, Data_out(:, 5), '-s', 'Color', '#EDB120', "MarkerSize", 18,'LineWidth', 1.8)
    hold on
    semilogx(x, Data_out(:, 6), '-o', 'Color', 'magenta', "MarkerSize", 18,'LineWidth', 1.8)
    hold on
    semilogx(x, Data_out(:, 7), '-s', 'Color', 'green', "MarkerSize", 18,'LineWidth', 1.8)
    xticks([256 512 1024 2048]);
    %yticks([0 200 400 600 800 1000 1200 1400 1600]);
    xlim([256 2048]);
    ylim([0 1500]);
    ax = gca;
    ax.FontSize = 15; 
    grid on
    %ylabel('GFLOP/s', 'FontSize', 15);
    %xlabel('Block size', 'FontSize', 15); 
    lgd=legend('ICQRRP', 'ICQRRP+QP3', 'HQRRP', 'HQRRP+GEQR', 'HQRRP+CholQR', 'GEQRF', 'GEQP3')
    lgd.FontSize = 20;
    ax = gca
    ax.XAxis.FontSize = 20;
    ax.YAxis.FontSize = 20;
    %set(gca,'YScale','log');

end


function[Data_out] = data_preprocessing_best(Data_in, num_col_sizes, numiters)
    
    Data_out = [];
    %Data_out(:, 1) = Data_in(:, 1);

    i = 1;
    num_algs = 7;
    for k = 1:num_algs
        k
        Data_out_col = [];
        while i < num_col_sizes * numiters
            best_speed = intmax;
            best_speed_idx = i;
            for j = 1:numiters
                if Data_in(i, k) < best_speed
                    best_speed = Data_in(i, k);
                    best_speed_idx = i;
                end
                i = i + 1;
            end
            best_speed_idx
            Data_out_col = [Data_out_col; Data_in(best_speed_idx, k)]; %#ok<AGROW>
        end
        i = 1;
        Data_out = [Data_out, Data_out_col];
    end
end