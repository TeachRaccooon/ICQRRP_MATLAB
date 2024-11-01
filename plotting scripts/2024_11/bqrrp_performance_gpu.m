function[] = bqrrp_performance_gpu()
    Data_in_32k = dlmread('../../DATA_in/2024_11_re_running_all/H100/ICQRRP_GPU_speed_rows_32768_cols_32768_d_factor_1.0.dat');
    Data_in_16k = dlmread('../../DATA_in/2024_11_re_running_all/H100/ICQRRP_GPU_speed_rows_16384_cols_16384_d_factor_1.0.dat');

    rows1 = 2^15;
    cols1 = 2^15;

    rows2 = 2^14;
    cols2 = 2^14;

    num_block_sizes = 4;
    numiters = 3;

    labels = 0;

    % Vertically stacking 32k adn 16k data
    tiledlayout(2, 1,"TileSpacing","tight")
    nexttile
    process_and_plot(Data_in_32k, rows1, cols1, 1, 0, labels)
    nexttile
    process_and_plot(Data_in_16k, rows2, cols2, 1, 1, labels)
end

function[] = process_and_plot(Data_in, rows, cols, titles, row, labels)

    geqrf_tflop = (2 * rows * cols^2 - (2 / 3) * cols^3 + rows * cols + cols^2 + (14 / 3) * cols) / 10^12;

    for i = 1:28
        % The input data is in microseconds, we need TFLOP/s
        Data_out(i, 1) = geqrf_tflop / (Data_in(i, 4) / 10^6); %#ok<AGROW> % BQRRP_HQR
        Data_out(i, 2) = geqrf_tflop / (Data_in(i, 5) / 10^6); %#ok<AGROW> % BQRRP_CQR
        Data_out(i, 3) = geqrf_tflop / (Data_in(i, 6) / 10^6); %#ok<AGROW> % GEQRF
    end 

    % Making usre there's no variation in GEQRF
    Data_out(:, 3) = min(Data_out(:, 3)) * ones(size(Data_out, 3), 1);

    x = [32, 64, 96, 128, 160, 192, 224, 256, 288, 320, 352, 384, 416, 448, 480, 512, 640, 768, 896, 1024, 1152, 1280, 1408, 1536, 1664, 1792, 1920, 2048];
    plot(x, Data_out(:, 1), '-<', 'Color', '#EDB120', "MarkerSize", 18,'LineWidth', 1.8) % BQRRP_HQR
    hold on
    plot(x, Data_out(:, 2), '->', 'Color', 'black', "MarkerSize", 18,'LineWidth', 1.8) % BQRRP_CQR
    hold on
    plot(x, Data_out(:, 3), '', 'Color', 'blue',    "MarkerSize", 18,'LineWidth', 1.8) % GEQRF
    hold on
    xticks([32, 280, 512, 1024, 2048]);
    xlim([32 2048]);

    ax = gca;
    ax.XAxis.FontSize = 20;
    ax.YAxis.FontSize = 20;
    grid on

    if ~titles
        set(gca,'Yticklabel',[])
    end
    if row
        if labels
            xlabel('block size', 'FontSize', 20); 
        end
    else 
        if labels
            title('NVIDIA H100', 'FontSize', 20);
        end
        set(gca,'Xticklabel',[])
    end
    if ~row && titles 
        lgd = legend('GEQRF\_GPU','BQRRP\_CQR\_GPU', 'BQRRP\_HQR\_GPU');
        lgd.FontSize = 20;
        legend('Location','northeastoutside');
        if labels
            ylabel('32k data // TeraFLOP/s', 'FontSize', 20);
        end
    end
    if titles && row
        if labels
            ylabel('16k data // TeraFLOP/s', 'FontSize', 20);
        end
    end
end
