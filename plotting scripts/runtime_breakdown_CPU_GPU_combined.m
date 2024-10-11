function[] = runtime_breakdown_CPU_GPU_combined()
    tiledlayout(1, 3,"TileSpacing","tight")

    %Data_in_ICQRRP_CPU = dlmread('../DATA_in/2024_10_re_running_all/2024_10_06_EPYC-9354P/OpenMP32/CQRRP_runtime_breakdown_32768_cols_32768_b_sz_start_256_b_sz_end_1024_d_factor_1.000000.dat');
    Data_in_ICQRRP_CPU = dlmread('../DATA_in/2024_10_re_running_all/2024_10_10_CQRRP_runtime_breakdown_65536_cols_65536_b_sz_start_256_b_sz_end_2048_d_factor_1.000000.txt');
    Data_in_HQRRP      = dlmread('../DATA_in/2024_09_re_running_all/2024_09_16_ISAAC_HQRRP_runtime_breakdown_16384_cols_16384_b_sz_start_256_b_sz_end_2048_d_factor_1.000000.txt');
    Data_in_ICQRRP_GPU = dlmread('../DATA_in/2024_09_re_running_all/2024_09_18_ICQRRP_GPU_runtime_breakdown_innerQRF_0_rows_32768_cols_32768_d_factor_1.0.dat');

    Data_in_ICQRRP_CPU = data_preprocessing_best(Data_in_ICQRRP_CPU, 4, 3);
    Data_in_HQRRP      = data_preprocessing_best(Data_in_HQRRP, 4, 5);

        for j = 1 : size(Data_in_HQRRP, 1)
        % HQRRP
        Data_out_HQRRP(j, 1) = 100 * Data_in_HQRRP(j, 14)                  /Data_in_HQRRP(j, 11); %#ok<AGROW> % QRCP pivoting
        Data_out_HQRRP(j, 2) = 100 * Data_in_HQRRP(j, 16)                  /Data_in_HQRRP(j, 11); %#ok<AGROW> % QRCP gen_reflector 2
        Data_out_HQRRP(j, 3) = 100 * (Data_in_HQRRP(j, 13) + Data_in_HQRRP(j, 18) + Data_in_HQRRP(j, 15) + Data_in_HQRRP(j, 12) + Data_in_HQRRP(j, 17) + Data_in_HQRRP(j, 19))                  /Data_in_HQRRP(j, 11); %#ok<AGROW> % QRCP_other
        Data_out_HQRRP(j, 4) = 100 * Data_in_HQRRP(j, 25)                  /Data_in_HQRRP(j, 11); %#ok<AGROW> % QR gen_reflector 2
        Data_out_HQRRP(j, 5) = 100 * (Data_in_HQRRP(j, 23) + Data_in_HQRRP(j, 21) + Data_in_HQRRP(j, 22) + Data_in_HQRRP(j, 24) + Data_in_HQRRP(j, 26) + Data_in_HQRRP(j, 27) + Data_in_HQRRP(j, 28))                   /Data_in_HQRRP(j, 11); %#ok<AGROW> % QR_other
        Data_out_HQRRP(j, 6) = 100 * Data_in_HQRRP(j, 8)                   /Data_in_HQRRP(j, 11); %#ok<AGROW> % Update A
        Data_out_HQRRP(j, 7) = 100 * (Data_in_HQRRP(j, 10) + Data_in_HQRRP(j, 3) + Data_in_HQRRP(j, 4) + Data_in_HQRRP(j, 5) + Data_in_HQRRP(j, 9)) / Data_in_HQRRP(j, 11); %#ok<AGROW> % Other
    end

    nexttile

    bplot = bar(Data_out_HQRRP,'stacked');
    bplot(1).FaceColor = 'red';
    bplot(2).FaceColor = 'blue';
    bplot(3).FaceColor = '#77AC30';
    bplot(4).FaceColor = 'magenta';
    bplot(5).FaceColor = 'black';
    bplot(6).FaceColor = '#EDB120';
    bplot(7).FaceColor = 'cyan';
    
    bplot(1).FaceAlpha = 0.8;
    bplot(2).FaceAlpha = 0.8;
    bplot(3).FaceAlpha = 0.8;
    bplot(4).FaceAlpha = 0.8;
    bplot(5).FaceAlpha = 0.8;
    bplot(6).FaceAlpha = 0.8;
    bplot(7).FaceAlpha = 0.8;

%{
% Plot the stacked bar chart
bplot = bar(Data_out_HQRRP, 'stacked');
    
hatchfill2(bplot(1), 'cross', 'HatchAngle', 45, 'HatchDensity', 60, 'HatchColor', 'blue');
hatchfill2(bplot(2), 'single', 'HatchAngle', 45, 'HatchDensity', 60, 'HatchColor', 'blue');
hatchfill2(bplot(3), 'single', 'HatchAngle', 45, 'HatchDensity', 60, 'HatchColor', 'blue');
hatchfill2(bplot(4), 'single', 'HatchAngle', 45, 'HatchDensity', 60, 'HatchColor', 'blue');
hatchfill2(bplot(5), 'single', 'HatchAngle', 45, 'HatchDensity', 60, 'HatchColor', 'blue');

legendData = {'QRCP-piv', 'QRCP-larf', 'QRCP-other'};
[~, object_h, ~, ~] = legendflex(bplot, legendData);
hatchfill2(object_h(1), 'cross', 'HatchAngle', 45, 'HatchDensity', 60/4, 'HatchColor', 'black');
%}
    title('HQRRP runtime breakdown (on Dual AMD EPYC 7513)', 'FontSize', 12);
    ylabel('Runtime %', 'FontSize', 23);
    xlabel('Block size', 'FontSize', 23); 
    lgd = legend('QRCP-piv', 'QRCP-larf', 'QRCP-other', 'QR-larf', 'QR-other', 'Update M', 'Other');
    legend('Location','northeastoutside'); 
    set(gca,'XTickLabel',{'256', '512', '1024', '2048'});
    ylim([0 100]);
    ax = gca;
    ax.FontSize  = 23; 
    lgd.FontSize = 23;

    for i = 1:size(Data_in_ICQRRP_CPU, 1)
        Data_out_ICQRRP_CPU(i, 1) = 100 * Data_in_ICQRRP_CPU(i, 1)                  /Data_in_ICQRRP_CPU(i, 12); %#ok<AGROW> % SASO
        Data_out_ICQRRP_CPU(i, 2) = 100 * Data_in_ICQRRP_CPU(i, 3)                  /Data_in_ICQRRP_CPU(i, 12); %#ok<AGROW> % QRCP
        Data_out_ICQRRP_CPU(i, 3) = 100 * Data_in_ICQRRP_CPU(i, 4)                  /Data_in_ICQRRP_CPU(i, 12); %#ok<AGROW> % Preconditioning
        Data_out_ICQRRP_CPU(i, 4) = 100 * Data_in_ICQRRP_CPU(i, 5)                  /Data_in_ICQRRP_CPU(i, 12); %#ok<AGROW> % CholQR
        Data_out_ICQRRP_CPU(i, 5) = 100 * Data_in_ICQRRP_CPU(i, 6)                  /Data_in_ICQRRP_CPU(i, 12); %#ok<AGROW> % ORHR_COL
        Data_out_ICQRRP_CPU(i, 6) = 100 * Data_in_ICQRRP_CPU(i, 7)                  /Data_in_ICQRRP_CPU(i, 12); %#ok<AGROW> % Updating1
        Data_out_ICQRRP_CPU(i, 7) = 100 * (Data_in_ICQRRP_CPU(i, 11) + Data_in_ICQRRP_CPU(i, 8) + Data_in_ICQRRP_CPU(i, 9) + Data_in_ICQRRP_CPU(i, 10) + Data_in_ICQRRP_CPU(i, 2) ) /Data_in_ICQRRP_CPU(i, 12); %#ok<AGROW> % rest
    end

    nexttile
    bplot = bar(Data_out_ICQRRP_CPU,'stacked');
    bplot(1).FaceColor = 'green';
    bplot(2).FaceColor = 'blue';
    bplot(3).FaceColor = 'black';
    bplot(4).FaceColor = 'red';
    bplot(5).FaceColor = 'magenta';
    bplot(6).FaceColor = '#EDB120';
    bplot(7).FaceColor = 'cyan';
    
    bplot(1).FaceAlpha = 0.8;
    bplot(2).FaceAlpha = 0.8;
    bplot(3).FaceAlpha = 0.8;
    bplot(4).FaceAlpha = 0.8;
    bplot(5).FaceAlpha = 0.8;
    bplot(6).FaceAlpha = 0.8;
    bplot(7).FaceAlpha = 0.8;
    
    title('ICQRRP runtime breakdown (on Dual AMD EPYC 7513)');
    xlabel('Block size', 'FontSize', 23); 
    lgd = legend('Sketching','QRCP(M^{sk})', 'Precond', 'CholQR', 'Reconstruct Q', 'Update M', 'Other');
    legend('Location','northeastoutside'); 
    set(gca,'XTickLabel',{'256', '512', '1024', '2048'});
    ylim([0 100]);
    ax = gca;
    ax.FontSize  = 23; 
    lgd.FontSize = 23;


    for i = 1:size(Data_in_ICQRRP_GPU, 1)
        Data_out_ICQRRP_GPU(i, 1)  = 100 * (Data_in_ICQRRP_GPU(i, 4) + Data_in_ICQRRP_GPU(i, 5) + Data_in_ICQRRP_GPU(i, 6))   / Data_in_ICQRRP_GPU(i, 18); %#ok<AGROW> % QRCP
        Data_out_ICQRRP_GPU(i, 2)  = 100 * (Data_in_ICQRRP_GPU(i, 8) + Data_in_ICQRRP_GPU(i, 9))                                /Data_in_ICQRRP_GPU(i, 18); %#ok<AGROW> % PIV(A) + Precond(A)
        Data_out_ICQRRP_GPU(i, 3)  = 100 * Data_in_ICQRRP_GPU(i, 10)                                                          /Data_in_ICQRRP_GPU(i, 18); %#ok<AGROW> % QRF / CholQR
        Data_out_ICQRRP_GPU(i, 4)  = 100 * Data_in_ICQRRP_GPU(i, 11)                                                          /Data_in_ICQRRP_GPU(i, 18); %#ok<AGROW> % ORHR_COL
        Data_out_ICQRRP_GPU(i, 5)  = 100 * Data_in_ICQRRP_GPU(i, 12)                                                          /Data_in_ICQRRP_GPU(i, 18); %#ok<AGROW> % ORMQR(A)
        Data_out_ICQRRP_GPU(i, 6)  = 100 * (Data_in_ICQRRP_GPU(i, 17) + Data_in_ICQRRP_GPU(i, 16) + Data_in_ICQRRP_GPU(i, 15) + Data_in_ICQRRP_GPU(i, 14) + Data_in_ICQRRP_GPU(i, 13) + Data_in_ICQRRP_GPU(i, 7) + Data_in_ICQRRP_GPU(i, 3))/Data_in_ICQRRP_GPU(i, 18); %#ok<AGROW> % t_rest
    end

    nexttile
    bplot = bar(Data_out_ICQRRP_GPU,'stacked');
    bplot(1).FaceColor  = 'blue';
    bplot(2).FaceColor  = 'black';
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
    
    title('ICQRRP runtime breakdown (on H100)');
    xlabel('Block size', 'FontSize', 23); 
    lgd = legend('QRCP(M^{sk})','Precond', 'CholQR', 'Reconstruct Q', 'Update M', 'Other');
    legend('Location','northeastoutside'); 
    set(gca,'XTickLabel',{'32', '', '', '256', '', '', '2048'});
    ylim([0 100]);
    ax = gca;
    ax.FontSize  = 23; 
    lgd.FontSize = 23;
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