function[] = bqrrp_subroutine_performance_tall_qr()
    Data_in_Intel = dlmread('../../DATA_in/2024_11_re_running_all/SapphireRapids/ICQRRP_subroutines_speed_comp_65536_col_start_256_col_stop_2048.dat');
    Data_in_AMD   = zeros(size(Data_in_Intel));

    rows = 2^16;
    cols = 256;

    num_block_sizes = 4;
    numiters = 3;

    labels = 0;

    % Horizontally stacking Intel and AMD machines
    tiledlayout(1, 2,"TileSpacing","tight")
    nexttile
    process_and_plot(Data_in_Intel, num_block_sizes, numiters, rows, cols, 1, labels)
    nexttile
    process_and_plot(Data_in_AMD,   num_block_sizes, numiters, rows, cols, 0, labels)

end

function[] = process_and_plot(Data_in, num_block_sizes, numiters, rows, cols, titles, labels)

    % Trim off the first benchmark
    Data_in = Data_in((num_block_sizes * numiters)+1:(2 * num_block_sizes * numiters), :);
    Data_in = data_preprocessing_best(Data_in, num_block_sizes, numiters);

    for i = 1:num_block_sizes
        geqrf_gflop = (2 * rows * cols^2 - (2 / 3) * cols^3 + rows * cols + cols^2 + (14 / 3) * cols) / 10^12;
        cols = cols * 2;

        Data_out(i, 1) = geqrf_gflop / (Data_in(i, 1) / 10^6); %#ok<AGROW> % GEQRF
        Data_out(i, 2) = geqrf_gflop / (Data_in(i, 2) / 10^6); %#ok<AGROW> % GEQR
        Data_out(i, 3) = geqrf_gflop / (Data_in(i, 3) / 10^6); %#ok<AGROW  % CHOLQR
        Data_out(i, 4) = geqrf_gflop / ((Data_in(i, 3) + Data_in(i, 4) + Data_in(i, 5) + Data_in(i, 6)) / 10^6); %#ok<AGROW  % CHOLQR+dependencies

        Data_out(i, 5)  = geqrf_gflop / (Data_in(i, 7)  / 10^6);  %#ok<AGROW  % GEQRT NB 256
        Data_out(i, 6)  = geqrf_gflop / (Data_in(i, 8)  / 10^6);  %#ok<AGROW  % GEQRT NB 512
        Data_out(i, 7)  = geqrf_gflop / (Data_in(i, 9)  / 10^6);  %#ok<AGROW  % GEQRT NB 1024
        Data_out(i, 8)  = geqrf_gflop / (Data_in(i, 10)  / 10^6); %#ok<AGROW  % GEQRT NB 2048
    end

    x = [256 512 1024 2048];
    semilogx(x, Data_out(:, 1), '-^', 'Color', 'red', "MarkerSize", 18,'LineWidth', 1.8)   % GEQRF
    hold on
    semilogx(x, Data_out(:, 2), '-v', 'Color', '#EDB120', "MarkerSize", 18,'LineWidth', 1.8)    % GEQR
    hold on
    semilogx(x, Data_out(:, 3), '-<', 'Color', 'blue', "MarkerSize", 18,'LineWidth', 1.8)     % CHOLQR
    hold on
    semilogx(x, Data_out(:, 4), '->', 'Color', 'black', "MarkerSize", 18,'LineWidth', 1.8) % CHOLQR+dependencies

    hold on
    semilogx(x, Data_out(:, 5), '-*', 'Color', 'magenta', "MarkerSize", 18,'LineWidth', 1.8) % GEQRT NB 256
    hold on
    semilogx(x, Data_out(:, 6), '-*', 'Color', 'magenta', "MarkerSize", 18,'LineWidth', 1.8) % GEQRT NB 512
    hold on
    semilogx(x, Data_out(:, 7), '-*', 'Color', 'magenta', "MarkerSize", 18,'LineWidth', 1.8) % GEQRT NB 1024
    hold on
    semilogx(x, Data_out(:, 8), '-*', 'Color', 'magenta', "MarkerSize", 18,'LineWidth', 1.8) % GEQRT NB 2048
    xticks([ 512  2048]);
    xlim([256 2048]);
    %ylim([0 3000]);

    ax = gca;
    ax.XAxis.FontSize = 20;
    ax.YAxis.FontSize = 20;
    grid on
    if labels
        xlabel('columns', 'FontSize', 20); 
        ax.FontSize = 20; 
    end

    if titles
        if labels
            ylabel('TeraFLOP/s', 'FontSize', 20);
            title('Intel Xeon Platinum 8462Y+', 'FontSize', 20);
        end
    else 
        lgd=legend('GEQRF', 'LATSQR', 'CholQR', 'CholQR + dep', 'GEQRT')
        lgd.FontSize = 20;
        legend('Location','northeastoutside');
        set(gca,'Yticklabel',[])
        if labels
            title('AMD ...', 'FontSize', 20);
        end
    end

end


function[Data_out] = data_preprocessing_best(Data_in, num_block_sizes, numiters)
    
    Data_out = [];

    i = 1;
    for k = 3:12
        Data_out_col = [];
        while i < num_block_sizes * numiters
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