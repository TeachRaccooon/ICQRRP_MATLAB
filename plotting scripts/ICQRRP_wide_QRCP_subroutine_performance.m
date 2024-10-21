function[] = ICQRRP_wide_QRCP_subroutine_performance()
    Data_in = dlmread('../DATA_in/2024_10_re_running_all/2024_10_11_ICQRRP_subroutines_speed_comp_65536_col_start_32_col_stop_2048.txt');

    cols = 2^16;
    rows = 32;

    num_block_sizes = 7;
    numiters = 5;

    % Trim off the first benchmark
    Data_in = Data_in(1:35, 1:5)

    Data_in = data_preprocessing_best(Data_in, num_block_sizes, numiters)

    for i = 1:num_block_sizes
        rows = rows * 2;
        geqrf_gflop = (2 * cols * rows^2 - (2 / 3) * rows^3 + 3 * cols * rows - rows^2 + (14 / 3) * cols) / 10^9;
    
        Data_out(i, 1) = geqrf_gflop / (Data_in(i, 1) / 10^6); %#ok<AGROW> % QP3
        Data_out(i, 2) = geqrf_gflop / (Data_in(i, 2) / 10^6); %#ok<AGROW> % LUQR
        Data_out(i, 3) = geqrf_gflop / (Data_in(i, 3) / 10^6); %#ok<AGROW  % CQRRPT
    end

    x = [32 64 128 256 512 1024 2048];
    semilogx(x, Data_out(:, 1), '-^', 'Color', 'black', "MarkerSize", 18,'LineWidth', 1.8)
    hold on
    semilogx(x, Data_out(:, 2), '-*', 'Color', 'blue', "MarkerSize", 18,'LineWidth', 1.8)
    hold on
    semilogx(x, Data_out(:, 3), '-o', 'Color', 'red', "MarkerSize", 18,'LineWidth', 1.8)
    xticks([32 64 128 256 512 1024 2048]);
    %yticks([0 200 400 600 800 1000 1200 1400 1600]);
    xlim([32 2048]);
    ylim([0 1500]);
    ax = gca;
    ax.FontSize = 15; 
    grid on
    ylabel('GigaFLOP/s', 'FontSize', 15);
    xlabel('d', 'FontSize', 15); 
    lgd=legend('GEQP3', 'LUQR', 'CQRRPT')
    lgd.FontSize = 20;
    ax = gca
    ax.XAxis.FontSize = 20;
    ax.YAxis.FontSize = 20;
    %set(gca,'YScale','log');

end


function[Data_out] = data_preprocessing_best(Data_in, num_block_sizes, numiters)
    
    Data_out = [];

    i = 1;
    for k = 3:5
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