function[] = QP3_vs_QRF()
    Data_in = dlmread('../Data_in/2024_06_re_running_all/2024_06_18_HASWELL_GEQRF_GEQP3_HQRRP_1k_10k_14_threads.txt');

    rows = [1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000];

    Data_in = data_preprocessing_mean(Data_in, 10, 20)

    Data_out = [];
    for i = 1:size(Data_in, 1)

        geqrf_gflop = (2 * rows(1, i) * rows(1, i)^2 - (2 / 3) * rows(1, i)^3 + rows(1, i) * rows(1, i) + rows(1, i)^2 + (14 / 3) * rows(1, i)) / 10^9;

        Data_out(i, 1) = geqrf_gflop / (Data_in(i, 6) / 10^6); %#ok<AGROW> % GEQRF
        Data_out(i, 2) = geqrf_gflop / (Data_in(i, 7) / 10^6); %#ok<AGROW> % GEQP3
        Data_out(i, 3) = geqrf_gflop / (Data_in(i, 3) / 10^6); %#ok<AGROW  % HQRRP plain
    end
    Data_out

    x = [1000 2000 3000 4000 5000 6000 7000 8000 9000 10000];
    plot(x, Data_out(:, 1), '-^', 'Color', 'blue', "MarkerSize", 18,'LineWidth', 1.8)
    hold on
    plot(x, Data_out(:, 2), '-*', 'Color', 'red', "MarkerSize", 18,'LineWidth', 1.8)
    hold on
    plot(x, Data_out(:, 3), '-o', 'Color', 'black', "MarkerSize", 18,'LineWidth', 1.8)
    %set(gca,'YScale','log');
    %set(gca,'XScale','log');

    xticks([2000 4000 6000 8000 10000]);
    %yticks([0 200 400 600 800 1000 1200 1400 1600]);
    xlim([1000 10000]);
    %ylim([0 1600]);
    ax = gca;
    ax.FontSize = 15; 
    grid on
    %ylabel('GFLOP/s', 'FontSize', 15);
    %xlabel('Block size', 'FontSize', 15); 
    %lgd=legend('GEQRF', 'GEQP3')
    %lgd.FontSize = 20;
    ax = gca
    ax.XAxis.FontSize = 20;
    ax.YAxis.FontSize = 20;


end


function[Data_out] = data_preprocessing_best(Data_in, num_col_sizes, numiters)
    
    Data_out = [];
    %Data_out(:, 1) = Data_in(:, 1);

    i = 1;
    num_algs = 7;
    for k = 1:num_algs
        Data_out_col = [];
        while i < num_col_sizes * numiters
            best_speed = intmax;
            best_speed_idx = 0;
            for j = 1:numiters
                if Data_in(i, k) < best_speed
                    best_speed = Data_in(i, k);
                    best_speed_idx = i;
                end
                i = i + 1;
            end
            Data_out_col = [Data_out_col; Data_in(best_speed_idx, k)] %#ok<AGROW>
        end
        i = 1;
        Data_out = [Data_out, Data_out_col];
    end
end

function[Data_out] = data_preprocessing_mean(Data_in, num_col_sizes, numiters)
    
    Data_out = [];
    %Data_out(:, 1) = Data_in(:, 1);

    i = 1;
    num_algs = 7;
    for k = 1:num_algs
        Data_out_col = [];
        while i < num_col_sizes * numiters
            sum_speed = 0;
            best_speed_idx = 0;
            for j = 1:numiters
                sum_speed = sum_speed + Data_in(i, k);
                i = i + 1;
            end
            Data_out_col = [Data_out_col; sum_speed / numiters] %#ok<AGROW>
        end
        i = 1;
        Data_out = [Data_out, Data_out_col];
    end
end