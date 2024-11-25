function[] = ICQRRP_CPU_GPU_combined()
    figure;

    %Data_in_cpu = dlmread('../DATA_in/2024_10_re_running_all/2024_10_06_EPYC-9354P/OpenMP32/ICQRRP_time_raw_rows_32768_cols_32768_b_sz_start_256_b_sz_end_1024_d_factor_1.000000.dat');
    Data_in_cpu = dlmread('../DATA_in/2024_10_re_running_all/2024_10_10_ICQRRP_time_raw_rows_65536_cols_65536_b_sz_start_256_b_sz_end_2048_d_factor_1.000000.txt');
    Data_in_gpu = dlmread('../DATA_in/2024_10_re_running_all/2024_10_02_ICQRRP_GPU_speed_rows_32768_cols_32768_d_factor_1.0.txt');

    rows = 2^16;
    cols = 2^16;

    Data_in_cpu = data_preprocessing_best(Data_in_cpu, 4, 3)

    geqrf_tflop = (2 * rows * cols^2 - (2 / 3) * cols^3 + rows * cols + cols^2 + (14 / 3) * cols) / 10^12;
for i = 1:4
    Data_out_cpu(i, 1) = geqrf_tflop / (Data_in_cpu(i, 1) / 10^6); %#ok<AGROW> % ICQRRP_best
    Data_out_cpu(i, 2) = geqrf_tflop / (Data_in_cpu(i, 2) / 10^6); %#ok<AGROW> % ICQRRP_QP3
    Data_out_cpu(i, 3) = geqrf_tflop / (Data_in_cpu(i, 3) / 10^6); %#ok<AGROW  % HQRRP
    Data_out_cpu(i, 4) = geqrf_tflop / (Data_in_cpu(i, 4) / 10^6); %#ok<AGROW> % HQRRP_GEQRF
    Data_out_cpu(i, 5) = geqrf_tflop / (Data_in_cpu(i, 5) / 10^6); %#ok<AGROW> % HQRRP_CholQR
    Data_out_cpu(i, 6) = geqrf_tflop / (Data_in_cpu(i, 6) / 10^6); %#ok<AGROW> % GEQRF
    Data_out_cpu(i, 7) = geqrf_tflop / (Data_in_cpu(i, 7) / 10^6); %#ok<AGROW> % GEQP3
end

    rows = 2^15;
    cols = 2^15;

    geqrf_tflop = (2 * rows * cols^2 - (2 / 3) * cols^3 + rows * cols + cols^2 + (14 / 3) * cols) / 10^12;

for i = 1:28
    % The input data is in microseconds, we need TFLOP/s
    Data_out_gpu(i, 1) = geqrf_tflop / (Data_in_gpu(i, 4) / 10^6); %#ok<AGROW> % ICQRRP_GPU_best
    Data_out_gpu(i, 2) = geqrf_tflop / (Data_in_gpu(i, 5) / 10^6); %#ok<AGROW> % QRF_GPU
    Data_out_gpu(i, 3) = geqrf_tflop / (Data_in_gpu(i, 6) / 10^6); %#ok<AGROW> % QRF_GPU
end 

    subplot(1, 1, 1);
    x = [256 512 1024 2048];
    semilogx(x, Data_out_cpu(:, 1), '-*', 'Color', 'black', "MarkerSize", 18,'LineWidth', 1.8)
    hold on
    %loglog(x, Data_out_cpu(:, 2), '->', 'Color', '#00FFFF', "MarkerSize", 18,'LineWidth', 1.8)
    %hold on
    semilogx(x, Data_out_cpu(:, 3), '-o', 'Color', 'magenta', "MarkerSize", 18,'LineWidth', 1.8)
    hold on
    %semilogx(x, Data_out_cpu(:, 4), '-s', 'Color', '#00FFFF', "MarkerSize", 18,'LineWidth', 1.8)
    %hold on
    %semilogx(x, Data_out_cpu(:, 5), '-s', 'Color', '#EDB120', "MarkerSize", 18,'LineWidth', 1.8)
    %hold on
    semilogx(x, Data_out_cpu(:, 6), '', 'Color', 'blue', "MarkerSize", 18,'LineWidth', 2.2)
    hold on
    semilogx(x, Data_out_cpu(:, 7), '', 'Color', 'red', "MarkerSize", 18,'LineWidth', 2.2)
    hold on
    buffer = -1000 * ones(28, 1);
    y = [32, 64, 96, 128, 160, 192, 224, 256, 288, 320, 352, 384, 416, 448, 480, 512, 640, 768, 896, 1024, 1152, 1280, 1408, 1536, 1664, 1792, 1920, 2048];
    plot(y, buffer, '-<', 'Color', '#EDB120',     "MarkerSize", 18,'LineWidth', 1.8)
    
    xticks([256 512 1024 2048]);
    yticks([0 0.5 1 1.5]);
    xlim([256 2048]);
    ylim([0 1.5]);
    ax = gca;
    ax.FontSize = 15; 
    grid on
    ylabel('Tera FLOP/s', 'FontSize', 15);
    xlabel('Block size', 'FontSize', 15); 
    title('CPU algorithms');
    lgd=legend('ICQRRP', 'HQRRP', 'GEQRF', 'GEQP3', 'IHQRRP')
    lgd.FontSize = 20;
    ax = gca
    ax.XAxis.FontSize = 20;
    ax.YAxis.FontSize = 20;
%{
    subplot(1, 1, 1);
    x = [32, 64, 96, 128, 160, 192, 224, 256, 288, 320, 352, 384, 416, 448, 480, 512, 640, 768, 896, 1024, 1152, 1280, 1408, 1536, 1664, 1792, 1920, 2048];
    plot(x, Data_out_gpu(:, 1), '-<', 'Color', '#EDB120',   "MarkerSize", 18,'LineWidth', 1.8)
    hold on
    plot(x, Data_out_gpu(:, 2), '-*', 'Color', 'black', "MarkerSize", 18,'LineWidth', 1.8)
    hold on
    plot(x, Data_out_gpu(:, 3), '', 'Color', 'blue',     "MarkerSize", 18,'LineWidth', 2.2)
    hold on
    % Using these buffers to create the common legend for the two plots.
    % Probably not the best approach.
    buffer = -1000 * ones(28, 1);
    plot(x, buffer, '-o', 'Color', 'magenta',     "MarkerSize", 18,'LineWidth', 1.8)
    hold on
    plot(x, buffer, '', 'Color', 'red',     "MarkerSize", 18,'LineWidth', 2.2)
    xticks([32, 280, 512, 1024, 2048]);
    xlim([32 2048]);
    ylim([0 20]);
    ax = gca;
    ax.FontSize = 15; 
    grid on

    title('GPU algorithms');
    xlabel('Block size', 'FontSize', 15); 
    %lgd=legend('IHQRRP', 'ICQRRP', 'GEQRF', 'HQRRP', 'GEQP3')
    lgd.FontSize = 20;
    ax = gca
    ax.XAxis.FontSize = 20;
    ax.YAxis.FontSize = 20;
%}
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