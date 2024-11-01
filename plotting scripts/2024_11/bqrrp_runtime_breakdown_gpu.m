function[] = bqrrp_runtime_breakdown_gpu()
    Data_in_CQR = dlmread('../../DATA_in/2024_11_re_running_all/H100/ICQRRP_GPU_runtime_breakdown_innerQRF_0_rows_32768_cols_32768_d_factor_1.0.dat');
    Data_in_HQR = dlmread('../../DATA_in/2024_11_re_running_all/H100/ICQRRP_GPU_runtime_breakdown_innerQRF_1_rows_32768_cols_32768_d_factor_1.0.dat');

    labels = 0;

    % Vertically stacking BQRRP_CQR and BQRRP_HQR
    tiledlayout(2, 1,"TileSpacing","tight")
    nexttile
    process_and_plot(Data_in_CQR, 1, 0, labels)
    nexttile
    process_and_plot(Data_in_HQR, 1, 1, labels)

end

function[] = process_and_plot(Data_in, titles, row, labels)

    for i = 1:size(Data_in, 1)
        Data_out(i, 6)  = 100 * (Data_in(i, 4) + Data_in(i, 5) + Data_in(i, 6))   / Data_in(i, 18); %#ok<AGROW> % QRCP
        Data_out(i, 5)  = 100 * Data_in(i, 8)                                     /Data_in(i, 18); %#ok<AGROW> % PIV(A) 
        Data_out(i, 4)  = 100 * (Data_in(i, 10) + Data_in(i, 9))                  /Data_in(i, 18); %#ok<AGROW> % QRF / CholQR + Precond(A)
        Data_out(i, 3)  = 100 * Data_in(i, 11)                                    /Data_in(i, 18); %#ok<AGROW> % ORHR_COL
        Data_out(i, 2)  = 100 * Data_in(i, 12)                                    /Data_in(i, 18); %#ok<AGROW> % ORMQR(A)
        Data_out(i, 1)  = 100 * (Data_in(i, 17) + Data_in(i, 16) + Data_in(i, 15) + Data_in(i, 14) + Data_in(i, 13) + Data_in(i, 7) + Data_in(i, 3))/Data_in(i, 18); %#ok<AGROW> % t_rest
    end

    bplot = bar(Data_out,'stacked');
    bplot(6).FaceColor  = 'blue';
    bplot(5).FaceColor  = 'black';
    bplot(4).FaceColor  = 'red';
    bplot(3).FaceColor  = 'magenta';
    bplot(2).FaceColor  = '#EDB120';
    bplot(1).FaceColor  = 'cyan';
    
    bplot(1).FaceAlpha  = 0.8;
    bplot(2).FaceAlpha  = 0.8;
    bplot(3).FaceAlpha  = 0.8;
    bplot(4).FaceAlpha  = 0.8;
    bplot(5).FaceAlpha  = 0.8;
    bplot(6).FaceAlpha  = 0.8;

    ylim([0 100]);
    ax = gca;
    ax.FontSize  = 20; 
    lgd.FontSize = 20;
    set(gca,'XTickLabel',{'32', '', '128', '', '512', '', '2048'});

    if titles
        if labels
            ylabel('Runtime %', 'FontSize', 20);
        end
    else 
        set(gca,'Yticklabel',[])
    end
    if row
        if labels
            xlabel('block size', 'FontSize', 20); 
        end
    else 
        if labels
            title('NVIDIA H100', 'FontSize', 20);
        end
        set(gca,'Xticklabel',[])
    end
    if ~row && titles 
        lgd = legend('Other','Update M', 'Reconstruct Q', 'PanelQR', 'Pivoting', 'QRCP(M^{sk})');
        lgd.FontSize = 20;
        legend('Location','northeastoutside');
        if labels
            ylabel('CQR // Runtime %', 'FontSize', 20);
        end
    end
    if titles && row
        if labels
            ylabel('HQR // Runtime %', 'FontSize', 20);
        end
    end
end
