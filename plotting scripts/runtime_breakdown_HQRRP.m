function[] = runtime_breakdown_HQRRP()
    %tiledlayout(1,2)


    % The first two entries in the dataset are: num_krylov_iters, b_sz
    Data_in = dlmread('../DATA_in/2024_06_re_running_all/2024_07_12_Riley_HQRRP_runtime_breakdown.txt');
    Data_out     = [];
    Runtime_data = [];

    Data_in = data_preprocessing_best(Data_in, 4, 4);

    nexttile
    for j = 1 : size(Data_in, 1)
        % HQRRP
        %Data_out(j, 1) = 100 * Data_in(j, 3)                  /Data_in(j, 11); %#ok<AGROW> % Preallocation
        %Data_out(j, 2) = 100 * Data_in(j, 4)                  /Data_in(j, 11); %#ok<AGROW> % Sketching
        %Data_out(j, 3) = 100 * Data_in(j, 5)                  /Data_in(j, 11); %#ok<AGROW> % Downdating
        %Data_out(j, 1) = 100 * Data_in(j, 6)                  /Data_in(j, 11); %#ok<AGROW> % QRCP
        
        
        % QRCP
        %Data_out(j, 1)  = 100 * Data_in(j, 12)                  /Data_in(j, 11); %#ok<AGROW> % QRCP preallocation
        %Data_out(j, 1)  = 100 * Data_in(j, 13)                  /Data_in(j, 11); %#ok<AGROW> % QRCP norms
        Data_out(j, 1)  = 100 * Data_in(j, 14)                  /Data_in(j, 11); %#ok<AGROW> % QRCP pivoting
        %Data_out(j, 4)  = 100 * Data_in(j, 15)                  /Data_in(j, 11); %#ok<AGROW> % QRCP gen_reflector 1
        Data_out(j, 2)  = 100 * Data_in(j, 16)                  /Data_in(j, 11); %#ok<AGROW> % QRCP gen_reflector 2
        %Data_out(j, 6)  = 100 * Data_in(j, 17)                  /Data_in(j, 11); %#ok<AGROW> % QRCP downdating
        %Data_out(j, 7) = 100 * Data_in(j, 18)                  /Data_in(j, 11); %#ok<AGROW> % QRCP gen_T
        Data_out(j, 3) = 100 * (Data_in(j, 13) + Data_in(j, 18) + Data_in(j, 15) + Data_in(j, 12) + Data_in(j, 17) + Data_in(j, 19))                  /Data_in(j, 11); %#ok<AGROW> % QRCP_other
        
        %Data_out(j, 4) = 100 * Data_in(j, 7)                  /Data_in(j, 11); %#ok<AGROW> % QR
        
        %Data_out(j, 1)  = 100 * Data_in(j, 21)                  /Data_in(j, 11); %#ok<AGROW> % QR preallocation
        %Data_out(j, 1)  = 100 * Data_in(j, 22)                  /Data_in(j, 11); %#ok<AGROW> % QR norms
        %Data_out(j, 4)  = 100 * Data_in(j, 23)                  /Data_in(j, 11); %#ok<AGROW> % QR pivoting
        %Data_out(j, 4)  = 100 * Data_in(j, 24)                  /Data_in(j, 11); %#ok<AGROW> % QR gen_reflector 1
        Data_out(j, 4)  = 100 * Data_in(j, 25)                  /Data_in(j, 11); %#ok<AGROW> % QR gen_reflector 2
        %Data_out(j, 6)  = 100 * Data_in(j, 26)                  /Data_in(j, 11); %#ok<AGROW> % QR downdating
        %Data_out(j, 7) = 100 * Data_in(j, 27)                  /Data_in(j, 11); %#ok<AGROW> % QR gen_T
        Data_out(j, 5) = 100 * (Data_in(j, 23) + Data_in(j, 21) + Data_in(j, 22) + Data_in(j, 24) + Data_in(j, 26) + Data_in(j, 27) + Data_in(j, 28))                   /Data_in(j, 11); %#ok<AGROW> % QR_other
        
        
        
        Data_out(j, 6) = 100 * Data_in(j, 8)                  /Data_in(j, 11); %#ok<AGROW> % Update A
        %Data_out(j, 7) = 100 * Data_in(j, 9)                  /Data_in(j, 11); %#ok<AGROW> % Update sketch
        
        Data_out(j, 7) = 100 * (Data_in(j, 10) + Data_in(j, 3) + Data_in(j, 4) + Data_in(j, 5) + Data_in(j, 9)) / Data_in(j, 11); %#ok<AGROW> % Other
        
    
    
    end

    bplot = bar(Data_out,'stacked');
    bplot(1).FaceColor = 'red';
    bplot(2).FaceColor = 'blue';
    bplot(3).FaceColor = '#77AC30';
    bplot(4).FaceColor = 'magenta';
    bplot(5).FaceColor = 'black';
    bplot(6).FaceColor = '#EDB120';
    bplot(7).FaceColor = 'cyan';
    %bplot(8).FaceColor = 'cyan';
    %bplot(9).FaceColor = '#77AC30';
    %bplot(10).FaceColor = '#7E2F8E';
    %bplot(11).FaceColor = '#A2142F';
    
    bplot(1).FaceAlpha = 0.8;
    bplot(2).FaceAlpha = 0.8;
    bplot(3).FaceAlpha = 0.8;
    bplot(4).FaceAlpha = 0.8;
    bplot(5).FaceAlpha = 0.8;
    bplot(6).FaceAlpha = 0.8;
    bplot(7).FaceAlpha = 0.8;
    %bplot(8).FaceAlpha = 0.8;
    %bplot(9).FaceAlpha = 0.8;
    %bplot(10).FaceAlpha = 0.8;
    %bplot(11).FaceAlpha = 0.8;
    
    lgd = legend('QRCP-piv', 'QRCP-larf', 'QRCP-other', 'QR-larf', 'QR-other', 'Update A', 'Other')
    legend('Location','northeastoutside'); 
    set(gca,'XTickLabel',{'256', '512', '1024', '2048'});
    ylim([0 100]);
    ax = gca;
    ax.FontSize = 23; 
    lgd.FontSize = 15;

    nexttile
    
    rows = 2^14;
    cols = 2^14;

    geqrf_gflop = (2 * rows * cols^2 - (2 / 3) * cols^3 + rows * cols + cols^2 + (14 / 3) * cols) / 10^9;
    hqrrp_old_time = 3887494164;
    geqrf_gflop / (hqrrp_old_time / 10^6)

    for j = 1 : 4
        Runtime_data(j, 1) = geqrf_gflop / (Data_in(j, 11) / 10^6);
    end
    x = [256, 512, 1024, 2048];
    xticks([256 512 1024 2048])
    xticklabels({'256','512','1024', '2048'})
    plot(x, Runtime_data, '-s', 'Color', 'black', "MarkerSize", 20,'LineWidth', 2);
    xlim([256 2048]);
    ax = gca;
    ax.FontSize = 23; 
    lgd.FontSize = 15;

end

function[Data_out] = data_preprocessing_best(Data_in, num_col_sizes, numiters)
    
    Data_out = [];
    i = 1;

    Data_out = [];
    while i < num_col_sizes * numiters
        best_speed = intmax;
        best_speed_idx = i;
        for j = 1:numiters
            if Data_in(i, 11) < best_speed
                best_speed = Data_in(i, 11);
                best_speed_idx = i;
            end
            i = i + 1;
        end
        Data_out = [Data_out; Data_in(best_speed_idx, :)]; %#ok<AGROW>
    end
end