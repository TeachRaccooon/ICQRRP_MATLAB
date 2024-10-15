function[] = plot_spectrum()
    Data_in = dlmread('../DATA_in/2024_10_re_running_all/2024_10_02_A_generated_rows_4096_cols_4096_b_sz_256_d_factor_1.000000.dat');
    ratios = dlmread('../DATA_in/2024_10_re_running_all/2024_10_02_QR_sv_ratios_rows_4096_cols_4096_b_sz_256_d_factor_1.000000.dat');

    S = svd(Data_in);
    ratios_processed  = zeros(2, size(S, 1));
    
    size(ratios)
    for i = 1:size(S, 1)
        ratios_processed(1, i) = ratios(1, i) * S(i, 1);
        ratios_processed(2, i) = ratios(2, i) * S(i, 1);
    end

    x = 1:size(S,1);

    size(S)
    size(ratios_processed)

    semilogy(x, S, '', 'Color', 'black', "MarkerSize", 18,'LineWidth', 1.8)
    hold on
    semilogy(x, ratios_processed(2, :), '', 'Color', 'blue', "MarkerSize", 18,'LineWidth', 1.8)
    hold on
    semilogy(x, ratios_processed(1, :), '', 'Color', 'red', "MarkerSize", 18,'LineWidth', 1.0)

    ax = gca;
    ax.FontSize = 20; 
    grid on
    xlim([0 4100]);
    ylim([0 10]);
    %ylabel('sigma[k]', 'FontSize', 20);
    ylabel('R[k, k]', 'FontSize', 20);
    %ylabel('r_{k}/s_{k}', 'FontSize', 15);
    xlabel('k', 'FontSize', 20); 
    %lgd=legend(GEQP3', 'CQRRP')
    %lgd.FontSize = 18;
    set(gca, 'YScale', 'log')

end