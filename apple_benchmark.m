% Compares single-precision CQRRP to double geqrf and getrf
function[] = apple_benchmark()
    Data_in = dlmread('DATA_in/Apple_QR_time_raw_rows_65536_cols_65536_b_sz_start_256_b_sz_end_2048_d_factor_1.250000.txt');

    rows = 2^16;
    cols = 2^16;

    geqrf_gflop = (2 * rows * cols^2 - (2 / 3) * cols^3 + rows * cols + cols^2 + (14 / 3) * cols) / 10^9;
    getrf_gflop = ((rows * cols^2) - (1 / 3) * (cols^3) - (1/2) * (cols^2) + (5 / 6) * cols) / 10^9; 

    Data_out = [];
    for i = 1:size(Data_in, 1)
        Data_out(i, 1) = geqrf_gflop / (Data_in(i, 1) / 10^6); %#ok<AGROW> % CQRRP
        Data_out(i, 2) = geqrf_gflop / (Data_in(i, 2) / 10^6); %#ok<AGROW> % QR
        Data_out(i, 3) = getrf_gflop / (Data_in(i, 3) / 10^6); %#ok<AGROW> % LU
    end
    Data_out

    x = [256 512 1024 2048];
    plot(x, Data_out(:, 1), '-^', 'Color', 'black', "MarkerSize", 10,'LineWidth', 1.2)
    hold on
    plot(x, Data_out(:, 2), '-o', 'Color', 'red', "MarkerSize", 10,'LineWidth', 1.2)
    hold on
    plot(x, Data_out(:, 3), '-s', 'Color', 'blue', "MarkerSize", 10,'LineWidth', 1.2)
    xticks([256 512 1024 2048]);
    %yticks([0 50 150 250]);
    xlim([256 2048]);
    %ylim([0 2000]);
    ax = gca;
    ax.FontSize = 15; 
    grid on
    %ylabel('GFLOP/s', 'FontSize', 15);
    %xlabel('Block size', 'FontSize', 15); 
    legend('ICQRRP(single)', 'GEQRF(double)', 'GETRF(double)')

    %saveas(gcf,'DATA_out/Apple_QR_time_raw_rows_32768_cols_32768_b_sz_start_256_b_sz_end_2048_d_factor_1.000000.png')
end