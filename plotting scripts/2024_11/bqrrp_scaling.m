function[] = bqrrp_scaling()
    Data_in   = dlmread('../../Data_in/2024_11_re_running_all/EPYC/ICQRRP_THREADS_SCALING_1_8_24_36_64_128__time_raw_rows_32768_cols_32768_b_sz_start_1024_b_sz_end_1024_d_factor_1.000000.txt');

    rows = 2^15;
    cols = 2^15;
    num_thread_nums = 6;

    Data_out = [];
    geqrf_gflop = (2 * rows * cols^2 - (2 / 3) * cols^3 + rows * cols + cols^2 + (14 / 3) * cols) / 10^9;
    for i = 1:num_thread_nums
        Data_out(i, 1) = geqrf_gflop / (Data_in(i, 2) / 10^6); %#ok<AGROW> % BQRRP_CQR
        Data_out(i, 2) = geqrf_gflop / (Data_in(i, 3) / 10^6); %#ok<AGROW> % BQRRP_HQR
    end

    Data_out
end