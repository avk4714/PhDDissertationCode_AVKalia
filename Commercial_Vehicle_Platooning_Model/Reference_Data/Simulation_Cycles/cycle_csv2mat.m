function [strctName] = cycle_csv2mat(fileName)
%CYCLE_CSV2MAT Convert CSV drive cycles to MAT files.
%   The function takes a CSV file as an input argument and returns a MAT
%   structre with the following elements:
%   <strctName>.spd_mps
%   <strctName>.time_s
%   <strctName>.grade_pct

%   Read CSV content into a table.
temp = readtable(fileName);

%   Data Pre-Processing
%   1. Change Speed from mph to mps
temp2.time_s = temp.Time_seconds_;
temp2.spd_mps = temp.Speed_mph_ * 0.44704;
temp2.dist_m = cumsum(temp2.spd_mps);
temp2.grade_pct = zeros(size(temp2.spd_mps));

strctName = temp2;
end

