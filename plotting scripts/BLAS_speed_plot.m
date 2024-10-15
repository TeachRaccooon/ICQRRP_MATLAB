function[] = BLAS_speed_plot()
    Data_in = dlmread('../DATA_in/2024_10_re_running_all/2024_10_11_BLAS_performance_comp_col_start_1024_col_stop_16384.txt');


    dim = 2^10;

    Data_in = data_preprocessing_best(Data_in, 5, 5)

for i = 1:5
    dim = dim * 2;

    blas1_gflop = 2 * dim   / 10^9;
    blas2_gflop = 2 * dim^2 / 10^9;
    blas3_gflop = 2 * dim^3 / 10^9;

    Data_out(i, 1) = blas1_gflop / (Data_in(i, 1) / 10^6); %#ok<AGROW> % BLAS_1
    Data_out(i, 2) = blas2_gflop / (Data_in(i, 2) / 10^6); %#ok<AGROW> % BLAS_2
    Data_out(i, 3) = blas3_gflop / (Data_in(i, 3) / 10^6); %#ok<AGROW  % BLAS_3
end
    Data_out

    x = [1024 2048 4096 8192 16384];
    semilogx(x, Data_out(:, 1), '-^', 'Color', 'black', "MarkerSize", 18,'LineWidth', 1.8)
    hold on
    semilogx(x, Data_out(:, 2), '-*', 'Color', 'blue', "MarkerSize", 18,'LineWidth', 1.8)
    hold on
    semilogx(x, Data_out(:, 3), '-o', 'Color', 'red', "MarkerSize", 18,'LineWidth', 1.8)
    xticks([1024 2048 4096 8192 16384]);
    %yticks([0 200 400 600 800 1000 1200 1400 1600]);
    xlim([1024 8192]);
    ylim([0 10^4]);
    ax = gca;
    ax.FontSize = 15; 
    grid on
    ylabel('GigaFLOP/s', 'FontSize', 15);
    xlabel('n', 'FontSize', 15); 
    lgd=legend('BLAS lvl1', 'BLAS lvl2', 'BLAS lvl3')
    lgd.FontSize = 20;
    ax = gca
    ax.XAxis.FontSize = 20;
    ax.YAxis.FontSize = 20;
    set(gca,'YScale','log');

end


function[Data_out] = data_preprocessing_best(Data_in, num_dim_sizes, numiters)
    
    Data_out = [];

    i = 1;
    num_algs = 3;
    for k = 2:4
        Data_out_col = [];
        while i < num_dim_sizes * numiters
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