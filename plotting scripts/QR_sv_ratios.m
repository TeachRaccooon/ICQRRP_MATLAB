function[] = QR_sv_ratios()
    Data_in = dlmread('../DATA_in/2024_10_re_running_all/2024_10_02_QR_sv_ratios_rows_4096_cols_4096_b_sz_256_d_factor_1.000000.dat');

    size(Data_in)
    Data_in(:, 1:10)

    plot( Data_in(2, :), '', 'Color', 'blue', "MarkerSize", 1.2,'LineWidth', 0.3)
    hold on
    plot( Data_in(1, :), '', 'Color', 'red', "MarkerSize", 1.2,'LineWidth', 1.8)
    ax = gca;
    ax.FontSize = 20; 
    grid on
    xlim([0 4096]);
    %ylim([0 10]);
    %yticks([0 0.2 0.5 1 2 5 10]);
    ylabel('R[k, k]/sigma[k]', 'FontSize', 20);
    xlabel('k', 'FontSize', 20); 
    %lgd=legend('GEQP3', 'CQRRP')
    %lgd.FontSize = 18;
    set(gca, 'YScale', 'log')

    %saveas(gcf,'DATA_out/Kahan_QR_sv_ratios_rows_4096_cols_4096_b_sz_256_d_factor_1.125000.png')
end