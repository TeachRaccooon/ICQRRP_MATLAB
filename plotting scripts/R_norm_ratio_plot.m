function[] = R_norm_ratio_plot()
    Data_in = dlmread('DATA_in/Kahan_QR_R_norm_ratios_rows_4096_cols_4096_b_sz_256_d_factor_1.125000.dat');

    size(Data_in)
    Data_in(:, 1:10)

    plot( Data_in(1, :), '-o', 'Color', 'black', "MarkerSize", 1,'LineWidth', 1.0)
    ax = gca;
    ax.FontSize = 15; 
    grid on
    ylabel('||R_{qp3}[k+1:,:]||/||R_{cqrrp}[k+1:,:]||', 'FontSize', 15);
    xlabel('k', 'FontSize', 15); 
    set(gca, 'YScale', 'log')

    saveas(gcf,'DATA_out/Kahan_QR_R_norm_ratios_rows_4096_cols_4096_b_sz_256_d_factor_1.125000.png')
end