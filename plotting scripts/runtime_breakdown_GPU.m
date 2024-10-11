function[] = runtime_breakdown_GPU()
    Data_in = dlmread('../DATA_in/2024_09_re_running_all/2024_09_18_ICQRRP_GPU_runtime_breakdown_innerQRF_0_rows_32768_cols_32768_d_factor_1.0.dat');

    Data_out = [];

    Data_in
    
    for i = 1:size(Data_in, 1)
        %Data_out(i, 1)  = 100 * Data_in(i, 3)                  /Data_in(i, 18); %#ok<AGROW> % preallocation_t_dur
        %Data_out(i, 2)  = 100 * Data_in(i, 4)                  /Data_in(i, 18); %#ok<AGROW> % qrcp_main_t_dur
        %Data_out(i, 3)  = 100 * Data_in(i, 5)                  /Data_in(i, 18); %#ok<AGROW> % copy_A_sk_t_dur
        %Data_out(i, 4)  = 100 * Data_in(i, 6)                  /Data_in(i, 18); %#ok<AGROW> % qrcp_piv_t_dur
        %Data_out(i, 5)  = 100 * Data_in(i, 7)                  /Data_in(i, 18); %#ok<AGROW> % copy_A_t_dur
        %Data_out(i, 6)  = 100 * Data_in(i, 8)                  /Data_in(i, 18); %#ok<AGROW> % piv_A_t_dur
        %Data_out(i, 7)  = 100 * Data_in(i, 9)                  /Data_in(i, 18); %#ok<AGROW> % preconditioning_t_dur
        %Data_out(i, 8)  = 100 * Data_in(i, 10)                 /Data_in(i, 18); %#ok<AGROW> % cholqr_t_dur
        %Data_out(i, 9)  = 100 * Data_in(i, 11)                 /Data_in(i, 18); %#ok<AGROW> % orhr_col_t_dur
        %Data_out(i, 10) = 100 * Data_in(i, 12)                 /Data_in(i, 18); %#ok<AGROW> % updating_A_t_dur
        %Data_out(i, 11) = 100 * Data_in(i, 13)                 /Data_in(i, 18); %#ok<AGROW> % copy_J_t_dur
        %Data_out(i, 12) = 100 * Data_in(i, 14)                 /Data_in(i, 18); %#ok<AGROW> % updating_J_t_dur
        %Data_out(i, 13) = 100 * Data_in(i, 15)                 /Data_in(i, 18); %#ok<AGROW> % updating_R_t_dur
        %Data_out(i, 14) = 100 * Data_in(i, 16)                 /Data_in(i, 18); %#ok<AGROW> % updating_Sk_t_dur
        
        
        
        Data_out(i, 1)  = 100 * (Data_in(i, 4) + Data_in(i, 5) + Data_in(i, 6))   /Data_in(i, 18); %#ok<AGROW> % QRCP
        Data_out(i, 2)  = 100 * Data_in(i, 8)                                     /Data_in(i, 18); %#ok<AGROW> % PIV(A)
        Data_out(i, 3)  = 100 * Data_in(i, 10)                                    /Data_in(i, 18); %#ok<AGROW> % QRF / CholQR
        Data_out(i, 4)  = 100 * Data_in(i, 11)                                    /Data_in(i, 18); %#ok<AGROW> % ORHR_COL
        Data_out(i, 5)  = 100 * Data_in(i, 12)                                    /Data_in(i, 18); %#ok<AGROW> % ORMQR(A)

        Data_out(i, 6) = 100 * (Data_in(i, 17) + Data_in(i, 16) + Data_in(i, 15) + Data_in(i, 14) + Data_in(i, 13) + Data_in(i, 9) + Data_in(i, 7) + Data_in(i, 3))/Data_in(i, 18); %#ok<AGROW> % t_rest
    end

    Data_out

    bplot = bar(Data_out,'stacked');
    bplot(1).FaceColor  = 'black';
    bplot(2).FaceColor  = 'blue';
    bplot(3).FaceColor  = 'red';
    bplot(4).FaceColor  = 'magenta';
    bplot(5).FaceColor  = '#EDB120';
    bplot(6).FaceColor  = 'cyan';
    
    bplot(1).FaceAlpha  = 0.8;
    bplot(2).FaceAlpha  = 0.8;
    bplot(3).FaceAlpha  = 0.8;
    bplot(4).FaceAlpha  = 0.8;
    bplot(5).FaceAlpha  = 0.8;
    bplot(6).FaceAlpha  = 0.8;
    
    lgd = legend('QRCP','PIV(A)', 'CholQR', 'ORHR\_COL', 'ORMQR(A)', 'Other');

    ylabel('Runtime %', 'FontSize', 15);
    xlabel('Block size', 'FontSize', 15);
    legend('Location','northeastoutside'); 
    set(gca,'XTickLabel',{'32', '', '', '256', '', '', '2048'});
    ylim([0 100]);
    ax = gca;
    ax.FontSize = 23; 
    lgd.FontSize = 15;

end