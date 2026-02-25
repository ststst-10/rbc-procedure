function n = x_count_quarters(startQ, endQ)
%COUNTQUARTERS Count quarters inclusive between two quarter/date inputs.
%   startQ,endQ can be "1948Q1" or "01-Jan-1948" (dd-MMM-yyyy).
%   Returns the number of quarters inclusive (start and end included).

[ys, qs] = parseYQ(startQ);
[ye, qe] = parseYQ(endQ);

% map year-quarter to a single index: year*4 + quarter
is = ys*4 + qs;
ie = ye*4 + qe;

n = ie - is + 1;

if n < 0
    error('endQ is before startQ');
end
end

function [y, q] = parseYQ(val)
% Normalize and parse either "YYYYQ#" or "dd-MMM-yyyy".

s = string(val);
if numel(s) ~= 1
    error('Input must be a single date/quarter value.');
end

c = char(strtrim(s));
if numel(c) == 6 && c(5) == 'Q'
    y = str2double(c(1:4));
    q = str2double(c(6));
    if ~ismember(q, 1:4) || isnan(y)
        error('Invalid quarter format.');
    end
else
    dt = datetime(c, 'InputFormat', 'dd-MMM-yyyy');
    y = year(dt);
    q = ceil(month(dt) / 3);
end
end

