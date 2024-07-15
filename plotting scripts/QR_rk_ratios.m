function[] = QR_rk_ratios()
    Data_in = dlmread('../DATA_in/2024_06_re_running_all/2024_07_02_ELEPHANT_STEP_QR_R_norm_ratios_rows_1024_cols_1024_b_sz_256_d_factor_1.125000.txt');

    size(Data_in)

    plot( Data_in(1, :), '-o', 'Color', 'black', "MarkerSize", 1.4,'LineWidth', 1.0)
    ax = gca;
    ax.FontSize = 15; 
    grid on
    xlim([0 1024]);
    ylim([0.85 1.45]);
    yticks([0.85 1 1.15 1.30 1.45]);
    %ylabel('r_{qp3}_{k}/r_{cqrrp}_{k}', 'FontSize', 15);
    %xlabel('k', 'FontSize', 15); 
    set(gca, 'YScale', 'log')

    %saveas(gcf,'DATA_out/Kahan_QR_rk_ratios_rows_4096_cols_4096_b_sz_256_d_factor_1.125000.png')
end