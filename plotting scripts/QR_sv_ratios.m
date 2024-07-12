function[] = QR_sv_ratios()
    Data_in = dlmread('../DATA_in/2024_06_re_running_all/2024_07_02_ELEPHANT_SPIKE_QR_sv_ratios_rows_1024_cols_1024_b_sz_256_d_factor_1.125000.txt');

    size(Data_in)
    Data_in(:, 1:10)

    plot( Data_in(1, :), '-o', 'Color', 'red', "MarkerSize", 1.2,'LineWidth', 1.1)
    hold on
    plot( Data_in(2, :), '-s', 'Color', 'blue', "MarkerSize", 1.2,'LineWidth', 1.1)
    ax = gca;
    ax.FontSize = 15; 
    grid on
    xlim([0 1024]);
    ylim([0 10]);
    yticks([0 0.2 0.5 1 2 5 10]);
    %ylabel('r_{k}/s_{k}', 'FontSize', 15);
    %xlabel('k', 'FontSize', 15); 
    %lgd=legend('GEQP3', 'CQRRP')
    %lgd.FontSize = 18;
    set(gca, 'YScale', 'log')

    %saveas(gcf,'DATA_out/Kahan_QR_sv_ratios_rows_4096_cols_4096_b_sz_256_d_factor_1.125000.png')
end