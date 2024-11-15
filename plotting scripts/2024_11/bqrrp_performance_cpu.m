function[] = bqrrp_performance_cpu()
    Data_in_65k_Intel = dlmread('../../Data_in/2024_11_re_running_all/SapphireRapids/ICQRRP_time_raw_rows_65536_cols_65536_b_sz_start_256_b_sz_end_2048_d_factor_1.000000.txt');
    Data_in_32k_Intel = dlmread('../../Data_in/2024_11_re_running_all/SapphireRapids/ICQRRP_time_raw_rows_32768_cols_32768_b_sz_start_256_b_sz_end_2048_d_factor_1.000000.txt');
    Data_in_65k_AMD   = dlmread('../../Data_in/2024_11_re_running_all/EPYC/ICQRRP_time_raw_rows_65536_cols_65536_b_sz_start_256_b_sz_end_2048_d_factor_1.000000.txt');
    Data_in_32k_AMD   = dlmread('../../Data_in/2024_11_re_running_all/EPYC/ICQRRP_time_raw_rows_32768_cols_32768_b_sz_start_256_b_sz_end_2048_d_factor_1.000000.txt');

    rows1 = 2^16;
    cols1 = 2^16;

    rows2 = 2^15;
    cols2 = 2^15;

    num_block_sizes = 4;
    numiters = 3;

    labels = 0;

    % Vertically stacking 65k adn 32k data
    % Horizontally stacking Intel and AMD machines
    tiledlayout(2, 2,"TileSpacing","tight")
    nexttile
    process_and_plot(Data_in_65k_Intel, num_block_sizes, numiters, rows1, cols1, 1, 0, labels)
    nexttile
    process_and_plot(Data_in_65k_AMD, num_block_sizes, numiters, rows1, cols1, 0, 0, labels)
    nexttile
    process_and_plot(Data_in_32k_Intel, num_block_sizes, numiters, rows2, cols2, 1, 1, labels)
    nexttile
    process_and_plot(Data_in_32k_AMD, num_block_sizes, numiters, rows2, cols2, 0, 1, labels)
end


function[] = process_and_plot(Data_in, num_block_sizes, numiters, rows, cols, titles, row, labels)

    Data_in = data_preprocessing_best(Data_in, num_block_sizes, numiters);

    geqrf_gflop = (2 * rows * cols^2 - (2 / 3) * cols^3 + rows * cols + cols^2 + (14 / 3) * cols) / 10^9;
    for i = 1:4
        Data_out(i, 1) = geqrf_gflop / (Data_in(i, 1) / 10^6); %#ok<AGROW> % BQRRP_CQR
        Data_out(i, 2) = geqrf_gflop / (Data_in(i, 2) / 10^6); %#ok<AGROW> % BQRRP_HQR
        Data_out(i, 3) = geqrf_gflop / (Data_in(i, 3) / 10^6); %#ok<AGROW  % BQRRP_QRT
        Data_out(i, 4) = geqrf_gflop / (Data_in(i, 4) / 10^6); %#ok<AGROW> % HQRRP_BASIC
        Data_out(i, 5) = geqrf_gflop / (Data_in(i, 5) / 10^6); %#ok<AGROW> % HQRRP_CQR
        Data_out(i, 6) = geqrf_gflop / (Data_in(i, 6) / 10^6); %#ok<AGROW> % HQRRP_HQR
        Data_out(i, 7) = geqrf_gflop / (Data_in(i, 7) / 10^6); %#ok<AGROW> % GEQRF
        Data_out(i, 8) = geqrf_gflop / (Data_in(i, 8) / 10^6); %#ok<AGROW> % GEQP3
    end

    % Making usre there's no variation in GEQRF and GEQP3
    Data_out_GEQRF = Data_out(:, 7);
    Data_out_GEQRF = Data_out_GEQRF(~isinf(Data_out_GEQRF));
    Data_out(:, 7) = max(Data_out_GEQRF) * ones(size(Data_out, 7), 1);
    Data_out(:, 7) = max(Data_out(:, 7)) * ones(size(Data_out, 7), 1);
    Data_out(:, 8) = min(Data_out(:, 8)) * ones(size(Data_out, 8), 1);

    x = [256 512 1024 2048];
    semilogx(x, Data_out(:, 1), '->', 'Color', 'black', "MarkerSize", 18,'LineWidth', 1.8)   % BQRRP_CQR
    hold on
    semilogx(x, Data_out(:, 2), '-<', 'Color', '#EDB120', "MarkerSize", 18,'LineWidth', 1.8)   % BQRRP_HQR
    %hold on
    %loglog(x, Data_out(:, 3), '-d', 'Color', 'black', "MarkerSize", 18,'LineWidth', 1.8)   % BQRRP_QRT
    hold on
    semilogx(x, Data_out(:, 4), '-d', 'Color', 'magenta', "MarkerSize", 18,'LineWidth', 1.8) % HQRRP_BASIC
    %hold on
    %semilogx(x, Data_out(:, 5), '->', 'Color', 'magenta', "MarkerSize", 18,'LineWidth', 1.8) % HQRRP_CQR
    %hold on
    %semilogx(x, Data_out(:, 6), '-<', 'Color', 'magenta', "MarkerSize", 18,'LineWidth', 1.8) % HQRRP_HQR
    hold on
    semilogx(x, Data_out(:, 7), '  ', 'Color', 'red', "MarkerSize", 18,'LineWidth', 1.8)     % GEQRF
    hold on
    semilogx(x, Data_out(:, 8), '  ', 'Color', 'blue', "MarkerSize", 18,'LineWidth', 1.8)    % GEQP3

    xticks([256 512 1024 2048]);
    xlim([256 2048]);
    if rows > 60000
        ylim([0 6000]);
    else
        ylim([0 5000]);
    end
    ax = gca;
    ax.XAxis.FontSize = 20;
    ax.YAxis.FontSize = 20;
    grid on

    if ~titles
        set(gca,'Yticklabel',[])
    end
    if row
        xticks([ 512  2048])
        if labels
            xlabel('block size', 'FontSize', 20); 
        end
    else 
        set(gca,'Xticklabel',[])
    end
    if ~row && ~titles 
        lgd=legend('BQRRP\_CQR', 'BQRRP\_HQR', 'HQRRP', 'GEQRF', 'GEQP3');
        lgd.FontSize = 20;
        legend('Location','northeastoutside');
        if labels
            title('AMD ...', 'FontSize', 20);
        end
    end
    if ~row && titles
            if labels
                title('Intel Xeon Platinum 8462Y+', 'FontSize', 20);
                ylabel('65k data // GigaFLOP/s', 'FontSize', 20);
            end
    end
    if titles && row
        if labels
            ylabel('32k data // GigaFLOP/s', 'FontSize', 20);
        end
    end
end


function[Data_out] = data_preprocessing_best(Data_in, num_col_sizes, numiters)
    
    Data_out = [];

    i = 1;
    num_algs = 8;
    for k = 1:num_algs
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
            Data_out_col = [Data_out_col; Data_in(best_speed_idx, k)]; %#ok<AGROW>
        end
        i = 1;
        Data_out = [Data_out, Data_out_col];
    end
end