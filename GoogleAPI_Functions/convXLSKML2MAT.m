function convXLSKML2MAT(filename,savename)
%CONVXLSKML2MAT Summary of this function goes here
%   Detailed explanation goes here

%% 1. Load the excel data as a table
tst_tbl = readtable(filename);

%% 2. Determine the size of the table
[tbl_len,~] = size(tst_tbl);

%% 3. User Inputs

%% 4. Loop through the table to get data.
k = 0;          % This manages the number of elements
% l = 0;          % This manages the coordinates inside each structure
for i = 1:tbl_len
    if tst_tbl.Name(i) ~= ""
        k = k + 1;
        GMapDat{k}.name = tst_tbl.Name(i);
        l = 0;
    end
    if (tst_tbl.Name(i) == "") && (~isnan(tst_tbl.Longitude(i)))
        l = l + 1;
        GMapDat{k}.coords(l,1) = tst_tbl.Latitude(i);
        GMapDat{k}.coords(l,2) = tst_tbl.Longitude(i);
    end
        
end
%% 5. Save varaible as MAT file
save(savename,'GMapDat')
%outp = GMapDat;
end

