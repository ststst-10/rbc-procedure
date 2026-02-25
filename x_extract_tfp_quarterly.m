function x_extract_tfp_quarterly()
%EXTRACT_TFP_QUARTERLY Create DTFP and DTFP_UTIL quarterly files from quarterly_tfp.xlsx.
%   Reads quarterly_tfp.xlsx (sheet "quarterly") and writes DTFP.xlsx and
%   DTFP_UTIL.xlsx with a "Quarterly" sheet formatted like GDP.xlsx.

tfpFile = 'quarterly_tfp.xlsx';
gdpFile = 'GDP.xlsx';

% Get the GDP date column header (e.g., 'observation_date')
gdp = readtable(gdpFile, 'Sheet', 'Quarterly');
dateHeader = gdp.Properties.VariableNames{1};

raw = readcell(tfpFile, 'Sheet', 'quarterly');

% Find header row where first column is 'date'
firstCol = string(raw(:, 1));
headerRow = find(strcmpi(strtrim(firstCol), 'date'), 1, 'first');
if isempty(headerRow)
    error('Could not find header row with "date" in quarterly_tfp.xlsx.');
end

headers = string(raw(headerRow, :));
data = raw(headerRow+1:end, :);

colDate = find(headers == "date", 1, 'first');
colDtfp = find(headers == "dtfp", 1, 'first');
colDtfpUtil = find(headers == "dtfp_util", 1, 'first');

if isempty(colDate) || isempty(colDtfp) || isempty(colDtfpUtil)
    error('Required columns not found: date, dtfp, dtfp_util.');
end

dateStrAll = string(data(:, colDate));
hasText = ~ismissing(dateStrAll) & strlength(strtrim(dateStrAll)) > 0;
dateStrAll = dateStrAll(hasText);

% Keep only rows that look like YYYYQ# or YYYY:Q#
isQuarter = ~cellfun('isempty', regexp(cellstr(strtrim(dateStrAll)), '^\d{4}[:]?Q[1-4]$', 'once'));
dateStr = dateStrAll(isQuarter);

data = data(hasText, :);
data = data(isQuarter, :);

dtfp = cellfun(@toDouble, data(:, colDtfp));
dtfpUtil = cellfun(@toDouble, data(:, colDtfpUtil));

dates = quarterStringsToDatetime(dateStr);
dates.Format = 'dd-MMM-yyyy';

T1 = table(dates, dtfp, 'VariableNames', {dateHeader, 'DTFP'});
writetable(T1, 'DTFP.xlsx', 'Sheet', 'Quarterly');

T2 = table(dates, dtfpUtil, 'VariableNames', {dateHeader, 'DTFP_UTIL'});
writetable(T2, 'DTFP_UTIL.xlsx', 'Sheet', 'Quarterly');
end

function out = toDouble(x)
% Convert Excel cell to double, using NaN for empty/non-numeric.
if isnumeric(x)
    out = x;
elseif ismissing(x) || isempty(x)
    out = NaN;
else
    out = str2double(string(x));
    if isnan(out)
        out = NaN;
    end
end
end

function dt = quarterStringsToDatetime(qstr)
% Convert "YYYY:Q#" or "YYYYQ#" to datetime at first day of quarter.
qstr = string(qstr);
n = numel(qstr);
y = zeros(n, 1);
q = zeros(n, 1);

for i = 1:n
    s = char(strtrim(qstr(i)));
    tok = regexp(s, '^(\d{4})[:]?Q([1-4])$', 'tokens', 'once');
    if isempty(tok)
        error('Invalid quarter string: %s', s);
    end
    y(i) = str2double(tok{1});
    q(i) = str2double(tok{2});
end

month = (q - 1) * 3 + 1; % Q1->Jan, Q2->Apr, Q3->Jul, Q4->Oct
dt = datetime(y, month, 1);
end
