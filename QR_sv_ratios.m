function[] = QR_sv_ratios()
    Data_in = dlmread('DATA_in/Kahan_QR_sv_ratios_rows_4096_cols_4096_b_sz_256_d_factor_1.125000.dat');

    size(Data_in)
    Data_in(:, 1:10)

    plot( Data_in(1, :), '-o', 'Color', 'red', "MarkerSize", 1,'LineWidth', 1.0)
    hold on
    plot( Data_in(2, :), '-s', 'Color', 'blue', "MarkerSize", 1,'LineWidth', 1.0)
    ax = gca;
    ax.FontSize = 15; 
    grid on
    ylabel('r_{k}/s_{k}', 'FontSize', 15);
    xlabel('k', 'FontSize', 15); 
    legend('GEQP3', 'CQRRP')
    set(gca, 'YScale', 'log')

    saveas(gcf,'DATA_out/Kahan_QR_sv_ratios_rows_4096_cols_4096_b_sz_256_d_factor_1.125000.png')
end