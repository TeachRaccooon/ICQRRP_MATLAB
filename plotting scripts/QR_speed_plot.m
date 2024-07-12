function[] = QR_speed_plot()
    Data_in = dlmread('Data_in/2024_05_28_QR_speed/QR_speed_comp_131072_col_start_512_col_stop_8192.txt');

    rows = 2^17;
    cols = [2^9, 2^10, 2^11, 2^12, 2^13];

    Data_in = data_preprocessing(Data_in, 5, 50)

    Data_out = [];
    for i = 1:size(Data_in, 1)

        geqrf_gflop = (2 * rows * cols(1, i)^2 - (2 / 3) * cols(1, i)^3 + rows * cols(1, i) + cols(1, i)^2 + (14 / 3) * cols(1, i)) / 10^9

        Data_out(i, 1) = geqrf_gflop / (Data_in(i, 2) / 10^6); %#ok<AGROW> % GEQRF
        Data_out(i, 2) = geqrf_gflop / (Data_in(i, 3) / 10^6); %#ok<AGROW> % GEQR
        Data_out(i, 3) = geqrf_gflop / (Data_in(i, 4) / 10^6); %#ok<AGROW  % GEQR+UNGQR
        Data_out(i, 4) = geqrf_gflop / (Data_in(i, 5) / 10^6); %#ok<AGROW> % CholQR
    end
    Data_out

    x = [512 1024 2048 4096 8192];
    semilogx(x, Data_out(:, 4), '-^', 'Color', 'black', "MarkerSize", 18,'LineWidth', 1.8)
    hold on
    semilogx(x, Data_out(:, 1), '-*', 'Color', '#00FFFF', "MarkerSize", 18,'LineWidth', 1.8)
    hold on
    semilogx(x, Data_out(:, 2), '-o', 'Color', 'red', "MarkerSize", 18,'LineWidth', 1.8)
    hold on
    semilogx(x, Data_out(:, 3), '-s', 'Color', '#EDB120', "MarkerSize", 18,'LineWidth', 1.8)
    xticks([1024 4096]);
    yticks([0 200 400 600 800 1000 1200 1400 1600]);
    xlim([512 8192]);
    %ylim([0 1600]);
    ax = gca;
    ax.FontSize = 15; 
    grid on
    %ylabel('GFLOP/s', 'FontSize', 15);
    %xlabel('Block size', 'FontSize', 15); 
    lgd=legend('CholQR', 'GEQRF', 'GEQR', 'GEQRF+UNGQR')
    lgd.FontSize = 20;
    ax = gca
    ax.XAxis.FontSize = 20;
    ax.YAxis.FontSize = 20;


end


function[Data_out] = data_preprocessing(Data_in, num_col_sizes, numiters)
    
    Data_out = [];
    %Data_out(:, 1) = Data_in(:, 1);

    i = 1;
    num_algs = 5;
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
