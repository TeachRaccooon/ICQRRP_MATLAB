function[] = QR_rk_ratios()
    Data_in = dlmread('DATA_in/Kahan_QR_sv_ratios_rows_4096_cols_4096_b_sz_256_d_factor_1.125000.dat');

    plot( Data_in(1, :) ./ Data_in(2, :), '-o', 'Color', 'black', "MarkerSize", 1,'LineWidth', 1.0)
    ax = gca;
    ax.FontSize = 15; 
    grid on
    ylabel('r_{qp3}_{k}/r_{cqrrp}_{k}', 'FontSize', 15);
    xlabel('k', 'FontSize', 15); 
    set(gca, 'YScale', 'log')

    saveas(gcf,'DATA_out/Kahan_QR_rk_ratios_rows_4096_cols_4096_b_sz_256_d_factor_1.125000.png')
end