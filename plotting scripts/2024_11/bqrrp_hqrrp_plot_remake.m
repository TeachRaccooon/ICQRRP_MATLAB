function[] = bqrrp_hqrrp_plot_remake()
    Data_in   = dlmread('../../Data_in/2024_11_re_running_all/EPYC/ICQRRP_time_raw_combined.txt');

    num_mat_sizes = 9;
    num_block_sizes = 3;
    numiters = 3;

    process_and_plot(Data_in, num_mat_sizes, num_block_sizes, numiters)
end


function[] = process_and_plot(Data_in, num_mat_sizes, num_block_sizes, numiters)

    Data_out = [];
    size(Data_in)
    rows = 1000;
    cols = 1000;

    for j = 1:num_mat_sizes
        Data_in_curr_mat = data_preprocessing_best(Data_in(((j-1) * num_block_sizes * numiters + 1):(j * num_block_sizes * numiters), :), num_block_sizes, numiters);
        Data_in_curr_mat(:, 7) = max(Data_in_curr_mat(:, 7)) * ones(size(Data_in_curr_mat, 7), 1);
        Data_in_curr_mat(:, 6) = min(Data_in_curr_mat(:, 6)) * ones(size(Data_in_curr_mat, 6), 1);

        geqrf_gflop = (2 * rows * cols^2 - (2 / 3) * cols^3 + rows * cols + cols^2 + (14 / 3) * cols) / 10^9;
        for i = 1:3
            Data_out_curr(i, 1) = geqrf_gflop / (Data_in_curr_mat(i, 3) / 10^6); %#ok<AGROW> % HQRRP
            Data_out_curr(i, 2) = geqrf_gflop / (Data_in_curr_mat(i, 6) / 10^6); %#ok<AGROW> % QRF
            Data_out_curr(i, 3) = geqrf_gflop / (Data_in_curr_mat(i, 7) / 10^6); %#ok<AGROW> % QP3
        end
        Data_out = [Data_out; Data_out_curr];
        rows = rows + 1000;
        cols = cols + 1000;
    end

    x = [1000 2000 3000 4000 5000 6000 7000 8000 9000];
    semilogy(x, Data_out(3:3:end, 1), '-o', 'Color', 'black', "MarkerSize", 18,'LineWidth', 1.8) % HQRRP
    hold on
    semilogy(x, Data_out(1:3:end, 2), '-s', 'Color', 'red', "MarkerSize", 18,'LineWidth', 1.8)   % QRF
    hold on
    semilogy(x, Data_out(1:3:end, 3), '-^', 'Color', 'blue', "MarkerSize", 18,'LineWidth', 1.8)  % QP3

    lgd=legend('HQRRP', 'GEQRF', 'GEQP3');
    lgd.FontSize = 20;
    legend('Location','northeastoutside');
    ax = gca;
    ax.XAxis.FontSize = 20;
    ax.YAxis.FontSize = 20;
    grid on
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