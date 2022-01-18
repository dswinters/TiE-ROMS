%% generate_ROMS.m
% Usage: generate_ROMS(params)

% Description: Create a ready-to-compile ROMS file/folder structure. A code
%              templating system is used to overwrite placeholders in modified
%              ROMS Fortran routines with user-specified values.
%
% Inputs: params - a structure containing all user-defined parameters. See
%         generate_all.m
%
% Outputs: None
%
% Author: Dylan Winters (dylan.winters@oregonstate.edu)

function generate_ROMS(params)

% First ensure that the desired output directory exists
run_path = fullfile(params.folder,params.name);
if ~exist(run_path,'dir')
    mkdir(run_path)
end

% Ensure other necessary directories exist
dirs = {'Analytical','Build','Header'};
for i = 1:length(dirs)
    if ~exist(fullfile(run_path,dirs{i}),'dir')
        mkdir(fullfile(run_path,dirs{i}));
    end
end

% Copy some files
copyfile(params.header,fullfile(run_path,'Header'));
copyfile('../input/varinfo.dat',run_path);
copyfile('../input/riverplume1.in',run_path);


% ROMS wants numbers formatted as follows in fortran:
r8format=@(x) sprintf('%.5f_r8',x);

% Define how we want to substitute placeholders in template files with desired values.
% Create a structure containing filenames, variable names, and strings:
% {template1, output1, {var1, string1;
%                       var2, string2;
                            ...     };
%  template2, output2, {...}; ...}
%
% Now loop over the defined files, and replace
%   var1=PLACEHOLDER
% with
%   var1=string1
% in file1, and so on through the whole list.

subs = {
    '../code/ana_fsobc.h',...                          % input template
    fullfile(run_path,'Analytical','ana_fsobc.h'),...  % output file
    {'omega', r8format(params.omega);                  % substitutions
     'val', r8format(params.tidal_amp);
     'phase', r8format(params.tidal_phase)};

    '../code/ana_grid.h',...
    fullfile(run_path,'Analytical','ana_grid.h'),...
    {'Xsize', r8format(params.Xsize);
     'Esize', r8format(params.Esize);
     'depth', r8format(params.depth);
     'f0', r8format(params.f0);
     'beta', r8format(params.beta)};

    '../code/build_ROMS.sh',...
    fullfile(run_path,'build_ROMS.sh'),...
    {'MY_ROOT_DIR', params.ROMS_source;
     'MY_PROJECT_DIR', fullfile(params.folder,params.name)};

       };

write_template(subs)

% TODO: These will eventually be template files as well, just copy them for now.
copyfile('../code/ana_m2obc.h',fullfile(run_path,'Analytical'));
copyfile('../code/ana_psource.h',fullfile(run_path,'Analytical'));
