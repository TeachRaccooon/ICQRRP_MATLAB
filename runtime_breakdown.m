function[] = cqrrpt_inner_speed()
    Data_in = dlmread('DATA_in/CQRRP_inner_speed_16384_cols_16384_b_sz_start_256_b_sz_end_2048_d_factor_1.250000.txt');

    Data_out = [];

    size(Data_in)

    for i = 1:size(Data_in, 1)

        Data_out(i, 1) = 100 * Data_in(i, 1)                  /Data_in(i, 12); %#ok<AGROW> % SASO
        %Data_out(i, 2) = 100 * Data_in(i, 2)                  /Data_in(i, 12); %#ok<AGROW> % Preallocation
        Data_out(i, 2) = 100 * Data_in(i, 3)                  /Data_in(i, 12); %#ok<AGROW> % QRCP
        Data_out(i, 3) = 100 * Data_in(i, 4)                  /Data_in(i, 12); %#ok<AGROW> % Preconditioning
        Data_out(i, 4) = 100 * Data_in(i, 5)                  /Data_in(i, 12); %#ok<AGROW> % CholQR
        %Data_out(i, 6) = 100 * Data_in(i, 6)                  /Data_in(i, 12); %#ok<AGROW> % Reconstruction
        Data_out(i, 5) = 100 * Data_in(i, 7)                  /Data_in(i, 12); %#ok<AGROW> % Updating1
        %Data_out(i, 6) = 100 * Data_in(i, 8)                  /Data_in(i, 12); %#ok<AGROW> % Updating2
        %Data_out(i, 6) = 100 * Data_in(i, 9)                  /Data_in(i, 12); %#ok<AGROW> % Updating3
        %Data_out(i, 6) = 100 * Data_in(i, 10)                 /Data_in(i, 12); %#ok<AGROW> % r_piv
        
        Data_out(i, 6) = 100 * (Data_in(i, 11) + Data_in(i, 8) + Data_in(i, 9) + Data_in(i, 10) + Data_in(i, 6) + Data_in(i, 2) ) /Data_in(i, 12); %#ok<AGROW> % rest
    end

    bplot = bar(Data_out,'stacked');
    bplot(1).FaceColor = 'cyan';
    bplot(2).FaceColor = 'blue';
    bplot(3).FaceColor = 'red';
    bplot(4).FaceColor = 'black';
    bplot(5).FaceColor = '#EDB120';
    bplot(6).FaceColor = 'green';
    
    bplot(1).FaceAlpha = 0.8;
    bplot(2).FaceAlpha = 0.8;
    bplot(3).FaceAlpha = 0.8;
    bplot(4).FaceAlpha = 0.8;
    bplot(5).FaceAlpha = 0.8;
    bplot(6).FaceAlpha = 0.8;
    
    lgd = legend('SASO','QRCP', 'Precond', 'CholQR', 'Updating', 'Other')
    legend('Location','northeastoutside'); 
    set(gca,'XTickLabel',{'256', '', '1024', ''});
    ylim([0 100]);
    ax = gca;
    ax.FontSize = 23; 
    lgd.FontSize = 15;

    saveas(gcf,'DATA_out/CQRRP_inner_speed_16384_cols_16384_b_sz_start_256_b_sz_end_2048_d_factor_1.250000.png')
end