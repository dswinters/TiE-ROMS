function write_template(subs)

for nf = 1:size(subs,1) % Begin loop over files
    ftxt = fileread(subs{nf,1}); % Read full template file text
    for nv = 1:size(subs{nf,3},1) % Begin loop over variables
        % Locate "var=PLACEHOLDER" in template file
        expr = sprintf('%s *= *PLACEHOLDER',subs{nf,3}{nv,1}); % create regexp
        expr = strrep(expr,'(','\('); % Replace parens for regexp function
        expr = strrep(expr,')','\)');
        [i1,i2] = regexp(ftxt,expr,'start','end'); % start/end indices of expression

        % Replace "PLACEHOLDER" with desired text
        ftxt = cat(2, ...
                   ftxt(1:i1-1), ...
                   strrep(ftxt(i1:i2),'PLACEHOLDER',subs{nf,3}{nv,2}),...
                   ftxt(i2+1:end));

    end

    % Write new text to output file, create output folder if necessary
    if ~exist(fileparts(subs{nf,2}),'dir')
        mkdir(fileparts(subs{nf,2}));
    end
    fid = fopen(subs{nf,2},'w');
    fprintf(fid,'%s\n',ftxt);
    fclose(fid);
end
