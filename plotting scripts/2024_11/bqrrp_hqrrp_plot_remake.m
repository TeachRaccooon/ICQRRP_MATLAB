function[] = bqrrp_hqrrp_plot_remake()
    Data_in_AMD   = dlmread('../../Data_in/2024_11_re_running_all/EPYC/ICQRRP_time_raw_combined_AMD.txt');
    %Data_in_Intel   = dlmread('../../Data_in/2024_11_re_running_all/SapphireRapids/ICQRRP_time_raw_combined_Intel.txt');
    Data_in_Intel   = dlmread('../../Data_in/2024_11_re_running_all/SapphireRapids/ICQRRP_threads_time_combined.txt');

    size(Data_in_Intel)
    size(Data_in_AMD)

    num_mat_sizes = 9;
    num_thread_nums = 5;
    numiters = 30;

    tiledlayout(1, 2,"TileSpacing","tight")
    nexttile
    process_and_plot(Data_in_Intel, num_mat_sizes, num_thread_nums, 20, 0);
    nexttile
    process_and_plot(Data_in_AMD, num_mat_sizes, num_thread_nums, 15, 1);
end


function[] = process_and_plot(Data_in, num_mat_sizes, num_thread_nums, numiters, plot_num)

    Data_out = [];
    rows = 1000;
    cols = 1000;

    for j = 1:num_mat_sizes
        Data_in_curr_mat = data_preprocessing_best(Data_in(((j-1) * num_thread_nums * numiters + 1):(j * num_thread_nums * numiters), :), num_thread_nums, numiters);
        Data_in_curr_mat(:, 7) = max(Data_in_curr_mat(:, 7)) * ones(size(Data_in_curr_mat, 7), 1);
        Data_in_curr_mat(:, 6) = min(Data_in_curr_mat(:, 6)) * ones(size(Data_in_curr_mat, 6), 1);

        geqrf_gflop = (2 * rows * cols^2 - (2 / 3) * cols^3 + rows * cols + cols^2 + (14 / 3) * cols) / 10^9;
        for i = 1:num_thread_nums
            Data_out_curr(i, 1) = geqrf_gflop / (Data_in_curr_mat(i, 3) / 10^6); %#ok<AGROW> % HQRRP
            Data_out_curr(i, 2) = geqrf_gflop / (Data_in_curr_mat(i, 6) / 10^6); %#ok<AGROW> % QRF
            Data_out_curr(i, 3) = geqrf_gflop / (Data_in_curr_mat(i, 7) / 10^6); %#ok<AGROW> % QP3
        end
        Data_out = [Data_out; Data_out_curr];
        rows = rows + 1000;
        cols = cols + 1000;
    end

    x = [1000 2000 3000 4000 5000 6000 7000 8000 9000];
    semilogy(x, Data_out(1:num_thread_nums:end, 2), '-o', 'Color', 'red', "MarkerSize", 18,'LineWidth', 1.8)   % QRF
    hold on
    semilogy(x, Data_out(1:num_thread_nums:end, 3), '-s', 'Color', 'blue', "MarkerSize", 18,'LineWidth', 1.8)  % QP3
    hold on
    semilogy(x, Data_out(1:num_thread_nums:end, 1), '->', 'Color', 'black', "MarkerSize", 18,'LineWidth', 1.8) % HQRRP
    hold on
    semilogy(x, Data_out(2:num_thread_nums:end, 1), '-<', 'Color', 'black', "MarkerSize", 18,'LineWidth', 1.8) % HQRRP
    hold on
    semilogy(x, Data_out(3:num_thread_nums:end, 1), '-^', 'Color', 'black', "MarkerSize", 18,'LineWidth', 1.8) % HQRRP
    hold on
    semilogy(x, Data_out(4:num_thread_nums:end, 1), '-v', 'Color', 'black', "MarkerSize", 18,'LineWidth', 1.8) % HQRRP
    hold on
    semilogy(x, Data_out(5:num_thread_nums:end, 1), '-d', 'Color', 'black', "MarkerSize", 18,'LineWidth', 1.8) % HQRRP

    if plot_num
        lgd=legend('GEQRF', 'GEQP3', 'HQRRP 1', 'HQRRP 4', 'HQRRP 8', 'HQRRP 14', 'HQRRP MAX');
        lgd.FontSize = 20;
        legend('Location','northeastoutside');
        set(gca,'Yticklabel',[])
    end
    ylim([0 2500]);
    xticks([1000 3000 5000 7000 9000]);
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