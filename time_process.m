function[] = time_process()
    Data_in = dlmread('DATA_in/DATA1.txt');

    Data_out = [];
    for i = 1:size(Data_in, 1)
        Data_out(i, 1) = 100 * Data_in(i, 1) / (Data_in(i, 12)); %#ok<AGROW>
        Data_out(i, 2) = 100 * Data_in(i, 3) / (Data_in(i, 12)); %#ok<AGROW>
        Data_out(i, 3) = 100 * Data_in(i, 4) / (Data_in(i, 12)); %#ok<AGROW>
        Data_out(i, 4) = 100 * Data_in(i, 5) / (Data_in(i, 12)); %#ok<AGROW>
        Data_out(i, 5) = 100 * (Data_in(i, 7) + Data_in(i, 8) + Data_in(i, 9)) / (Data_in(i, 12)); %#ok<AGROW>
        Data_out(i, 6) = 100 * (Data_in(i, 2) + Data_in(i, 4) + Data_in(i, 6) + Data_in(i, 10) + Data_in(i, 11)) / (Data_in(i, 12)); %#ok<AGROW>
    end
    
    writematrix(Data_out, "Buf_in.txt");
end