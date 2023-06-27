% Use this script to plot the Morris results
%clear all;

% Load data 
date2save = "2023-06-27";
notes = "fullpars";

%% amt_gut
var = "amt_gut"
fname = strcat(date2save, '_MorrisAnalysis_var-', var,...
            "_notes-", notes, ".csv");
Tgut = readtable(fname, 'ReadRowNames',true);

%% amt_plas
var = "amt_plas"
fname = strcat(date2save, '_MorrisAnalysis_var-', var,...
            "_notes-", notes, ".csv");
Tplas = readtable(fname,'ReadRowNames',true);

%% amt_inter
var = "amt_inter"
fname = strcat(date2save, '_MorrisAnalysis_var-', var,...
            "_notes-", notes, ".csv");
Tint = readtable(fname,'ReadRowNames',true);

%% amt_muscle
var = "amt_muscle"
fname = strcat(date2save, '_MorrisAnalysis_var-', var,...
            "_notes-", notes, ".csv");
Tmusc = readtable(fname,'ReadRowNames',true);

%% parameter names list
parnames = ["Phi_Kin_ss", ...
            "kgut", ...
            "KMuscleBase", ...
            "Kecf_base", ...
            "Km", ... 
            "Vmax", ...
            "V_plasma", ...
            "V_inter", ...
            "V_muscle", ...
            "m_K_ALDO", ...
            "ALD_eq", ...
            "P_ECF", ...
            "FF", ...
            "GFR", ...
            "dtKsec_eq", ...
            "A_dtKsec", ...
            "B_dtKsec", ...
            "cdKsec_eq", ...
            "A_cdKsec", ...
            "B_cdKsec", ...
            "A_cdKreab", ...
            "A_insulin", ...
            "B_insulin" ...
            ];



%----------------------
% functions used
%----------------------


%% get time vals
function tvals = get_time_vals(parnames, T)
    tvals = zeros(length(parnames), 4, 3); % 1: mu, 2: mu*, 3: sigma
    for ii = 1:length(parnames)
        pname = parnames(ii);
        tvals(ii,:,1) = get_mu(T, pname);
        tvals(ii,2) = get_mustar(T, pname);
        tvals(ii,3) = get_sigma(T, pname);
    end
end

%% get sigma 
function sig_vals = get_sigma(T, pname)
    % Input
    %   T - table
    %   pname - parameter name
    nm = strcat('sigma_', pname);
    vals = T(nm, :);
    sig_vals = [vals.time1; vals.time2; vals.time3; vals.time4];
end

%% get mu star values
function mus_vals = get_mustar(T, pname)
    % Input
    %   T - table
    %   pname - parameter name
    nm = strcat('mu.star_', pname);
    vals = T(nm, :);
    mus_vals = [vals.time1; vals.time2; vals.time3; vals.time4];
end

%% get mu values
function mu_vals = get_mu(T, pname)
    % Input
    %   T - table
    %   pname - parameter name
    nm = strcat('mu_', pname);
    vals = T(nm, :);
    mu_vals = [vals.time1; vals.time2; vals.time3; vals.time4];
end

