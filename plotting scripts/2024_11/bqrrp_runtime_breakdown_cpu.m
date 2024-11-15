function[] = bqrrp_runtime_breakdown_cpu()
    Data_in_CQR_Intel = dlmread('../../DATA_in/2024_11_re_running_all/SapphireRapids/CQRRP_runtime_breakdown_65536_cols_65536_b_sz_start_256_b_sz_end_2048_d_factor_1.000000_panel_qr_cholqr.dat');
    Data_in_HQR_Intel = dlmread('../../DATA_in/2024_11_re_running_all/SapphireRapids/CQRRP_runtime_breakdown_65536_cols_65536_b_sz_start_256_b_sz_end_2048_d_factor_1.000000_panel_qr_geqrf.dat');
    Data_in_CQR_AMD   = dlmread('../../DATA_in/2024_11_re_running_all/EPYC/CQRRP_runtime_breakdown_65536_cols_65536_b_sz_start_256_b_sz_end_2048_d_factor_1.000000_panel_qr_cholqr.txt');
    Data_in_HQR_AMD   = dlmread('../../DATA_in/2024_11_re_running_all/EPYC/CQRRP_runtime_breakdown_65536_cols_65536_b_sz_start_256_b_sz_end_2048_d_factor_1.000000_panel_qr_geqrf.txt');


    num_block_sizes = 4;
    numiters = 3;

    labels = 0;

    % Vertically stacking BQRRP_CQR and BQRRP_HQR
    % Horizontally stacking Intel and AMD machines
    tiledlayout(2, 2,"TileSpacing","tight")
    nexttile
    process_and_plot(Data_in_CQR_Intel, num_block_sizes, numiters, 1, 0, labels)
    nexttile
    process_and_plot(Data_in_CQR_AMD, num_block_sizes, numiters, 0, 0, labels)
    nexttile
    process_and_plot(Data_in_HQR_Intel, num_block_sizes, numiters, 1, 1, labels)
    nexttile
    process_and_plot(Data_in_HQR_AMD, num_block_sizes, numiters, 0, 1, labels)

end

function[] = process_and_plot(Data_in, num_block_sizes, numiters, titles, row, labels)

    Data_in = data_preprocessing_best(Data_in, num_block_sizes, numiters);

    for i = 1:size(Data_in, 1)
        Data_out_ICQRRP_CPU(i, 7) = 100 * Data_in(i, 1)                  /Data_in(i, 12); %#ok<AGROW> % SASO
        Data_out_ICQRRP_CPU(i, 6) = 100 * Data_in(i, 3)                  /Data_in(i, 12); %#ok<AGROW> % QRCP
        Data_out_ICQRRP_CPU(i, 5) = 100 * Data_in(i, 4)                  /Data_in(i, 12); %#ok<AGROW> % Preconditioning
        Data_out_ICQRRP_CPU(i, 4) = 100 * Data_in(i, 5)                  /Data_in(i, 12); %#ok<AGROW> % CholQR
        Data_out_ICQRRP_CPU(i, 3) = 100 * Data_in(i, 6)                  /Data_in(i, 12); %#ok<AGROW> % ORHR_COL
        Data_out_ICQRRP_CPU(i, 2) = 100 * Data_in(i, 7)                  /Data_in(i, 12); %#ok<AGROW> % Updating1
        Data_out_ICQRRP_CPU(i, 1) = 100 * (Data_in(i, 11) + Data_in(i, 8) + Data_in(i, 9) + Data_in(i, 10) + Data_in(i, 2) ) /Data_in(i, 12); %#ok<AGROW> % rest
    end

    bplot = bar(Data_out_ICQRRP_CPU,'stacked');

    bplot(1).FaceColor = 'cyan';
    bplot(2).FaceColor = '#EDB120';
    bplot(3).FaceColor = 'magenta';
    bplot(4).FaceColor = 'red';
    bplot(5).FaceColor = 'black';
    bplot(6).FaceColor = 'blue';
    bplot(7).FaceColor = 'green';
    
    bplot(1).FaceAlpha = 0.8;
    bplot(2).FaceAlpha = 0.8;
    bplot(3).FaceAlpha = 0.8;
    bplot(4).FaceAlpha = 0.8;
    bplot(5).FaceAlpha = 0.8;
    bplot(6).FaceAlpha = 0.8;
    bplot(7).FaceAlpha = 0.8;
    
    ylim([0 100]);
    ax = gca;
    ax.FontSize  = 20; 
    lgd.FontSize = 20;
    set(gca,'XTickLabel',{'', '512', '', '2048'});

    if ~titles
        set(gca,'Yticklabel',[])
    end
    if row
        if labels
            xlabel('block size', 'FontSize', 20); 
        end
    else 
        set(gca,'Xticklabel',[])
    end
    if ~row && ~titles 
        lgd = legend('Other','Apply Q', 'Reconstruct Q', 'Tall QR', 'Permutation', 'QRCP(M^{sk})', 'Sketching');
        legend('Location','northeastoutside');
        if labels
            title('AMD ...', 'FontSize', 20);
        end
    end
    if ~row && titles
        if labels
            title('Intel Xeon Platinum 8462Y+', 'FontSize', 20);
            ylabel('CQR // Runtime %', 'FontSize', 20);
        end
    end
    if titles && row
        if labels
            ylabel('HQR // Runtime %', 'FontSize', 20);
        end
    end

end

function[Data_out] = data_preprocessing_best(Data_in, num_col_sizes, numiters)
    
    Data_out = [];
    i = 1;

    Data_out = [];
    while i < num_col_sizes * numiters
        best_speed = intmax;
        best_speed_idx = i;
        for j = 1:numiters
            if Data_in(i, 12) < best_speed
                best_speed = Data_in(i, 12);
                best_speed_idx = i;
            end
            i = i + 1;
        end
        Data_out = [Data_out; Data_in(best_speed_idx, :)]; %#ok<AGROW>
    end
end