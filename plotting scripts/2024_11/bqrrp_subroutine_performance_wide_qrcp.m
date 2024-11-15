function[] = bqrrp_subroutine_performance_wide_qrcp()
    Data_in_Intel = dlmread('../../DATA_in/2024_11_re_running_all/SapphireRapids/ICQRRP_subroutines_speed_comp_65536_col_start_256_col_stop_2048.dat');
    Data_in_AMD   = dlmread('../../DATA_in/2024_11_re_running_all/EPYC/ICQRRP_subroutines_speed_comp_65536_col_start_256_col_stop_2048.txt');

    cols = 2^16;

    rows = 256;

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
    Data_in = Data_in(1:(num_block_sizes * numiters), 1:5);
    Data_in = data_preprocessing_best(Data_in, num_block_sizes, numiters);

    for i = 1:num_block_sizes
        geqrf_gflop = (2 * cols * rows^2 - (2 / 3) * rows^3 + 3 * cols * rows - rows^2 + (14 / 3) * cols) / 10^9;
        rows = rows * 2;

        Data_out(i, 1) = geqrf_gflop / (Data_in(i, 1) / 10^6); %#ok<AGROW> % QP3
        Data_out(i, 2) = geqrf_gflop / (Data_in(i, 2) / 10^6); %#ok<AGROW> % LUQR
    end

    x = [256 512 1024 2048];
    semilogx(x, Data_out(:, 1), '-s', 'Color', 'blue', "MarkerSize", 18,'LineWidth', 1.8) % QP3
    hold on
    semilogx(x, Data_out(:, 2), '->', 'Color', 'black', "MarkerSize", 18,'LineWidth', 1.8)  % LUQR
    xticks([ 512  2048]);
    xlim([256 2048]);
    ylim([0 750]);
    ax = gca;
    ax.XAxis.FontSize = 20;
    ax.YAxis.FontSize = 20;
    grid on
    if labels
        xlabel('d', 'FontSize', 20); 
        ax.FontSize = 20; 
    end

    if titles
        if labels
            ylabel('TeraFLOP/s', 'FontSize', 20);
            title('Intel Xeon Platinum 8462Y+', 'FontSize', 20);
        end
    else 
        set(gca,'Yticklabel',[])
        lgd=legend('GEQP3', 'LUQR');
        lgd.FontSize = 20;
        legend('Location','northeastoutside'); 
        if labels
            title('AMD ...', 'FontSize', 20);
        end
    end
end

function[Data_out] = data_preprocessing_best(Data_in, num_block_sizes, numiters)
    
    Data_out = [];

    i = 1;
    for k = 3:4
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