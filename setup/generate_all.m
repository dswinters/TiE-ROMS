clear all, close all

% User ROMS directory
params.ROMS_source = '/home/dw/Work/temperature-in-estuaries/ROMS';

% Run info
params.folder = '/home/dw/Work/temperature-in-estuaries/runs';
params.name = 'test_run';
params.header = '../code/riverplume1.h';

% Tidal forcing parameters
params.omega = 2*pi/(12.42*3600.0); % Tidal forcing period [rad/sec]
params.tidal_amp = 0.5; % Tidal forcing amplitude at boundary [m]
params.tidal_phase = 0; % Tidal forcing initial phase [degrees]

% Domain parameters
params.f0    = 1e-4;   % Coriolis parameter, f-plane constant (1/s).
params.Xsize = 58.5e3; % Length (m) of domain box in the XI-direction.
params.Esize = 201e3;  % Length (m) of domain box in the ETA-direction.
params.depth = 150;    % Maximum depth of bathymetry (m).
params.beta  = 0;      % Coriolis parameter, beta-plane constant (1/s/m).

% Point source (river input) parameters


generate_ROMS(params);
