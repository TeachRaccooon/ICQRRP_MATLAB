function[] = plot_spectrum()
    %Data_in = dlmread('../../DATA_in/2024_11_re_running_all/PivotQualityResults/A_generated_rows_16384_cols_16384_b_sz_16384_d_factor_1.000000.dat');
    %S = svd(Data_in);
    %writematrix(S, '../../DATA_in/2024_11_re_running_all/PivotQualityResults/S_generated_rows_16384_cols_16384_b_sz_16384_d_factor_1.000000.txt');
    S = dlmread('../../DATA_in/2024_11_re_running_all/PivotQualityResults/S_generated_rows_16384_cols_16384_b_sz_16384_d_factor_1.000000.txt');
    x = 1:size(S, 1);
    semilogy(S, '', 'Color', 'black', "MarkerSize", 2.5,'LineWidth', 3.0)

    ax = gca;
    ax.FontSize = 20; 
    grid on
    xlim([0 16384]);
    ylim([10^-33 10^3]);
    xticks([4000 12000]);
end