function x_write_latex_table(tbl, filename, caption, label)
    fid = fopen(filename, 'w');

    % Header
    fprintf(fid, '\\begin{table}[!ht]\n\\centering\n');
    if ~isempty(caption), fprintf(fid, '\\caption{%s}\n', caption); end
    if ~isempty(label),   fprintf(fid, '\\label{%s}\n', label); end

    % Column alignment: 1 for row names + one per variable
    ncols = width(tbl) + 1;
    fprintf(fid, '\\begin{tabular}{l%s}\n', repmat('c',1,ncols-1));
    fprintf(fid, '\\hline\n');

    % Column names
    fprintf(fid, ' & %s \\\\\n', strjoin(tbl.Properties.VariableNames, ' & '));
    fprintf(fid, '\\hline\n');

    % Rows
    for i = 1:height(tbl)
        rowname = tbl.Properties.RowNames{i};
        rowvals = tbl{i,:};
        fprintf(fid, '%s', rowname);
        for j = 1:numel(rowvals)
            fprintf(fid, ' & %.2f', rowvals(j));
        end
        fprintf(fid, ' \\\\\n');
    end

    fprintf(fid, '\\hline\n\\end{tabular}\n\\end{table}\n');
    fclose(fid);
end
