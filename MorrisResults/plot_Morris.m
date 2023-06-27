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

%% get values
tvals_plas = get_time_vals(parnames, Tplas);
tvals_musc = get_time_vals(parnames, Tmusc);
tvals_inter = get_time_vals(parnames, Tint);
tvals_gut = get_time_vals(parnames, Tgut);

%% Make morris plot
% x-axis: mu_star
% y-axis: sigma
% time 4 plot, plasma
cmap = turbo(length(parnames));
marksize=25; ms = '.';
fx = 16; fy = 16; fleg = 12; ft = 18;
figure(1)
clf
mustar = tvals_plas(:, 4, 2);
%[sorted_mustar, inds] = sort(mustar); 
sigvals = tvals_plas(:, 4, 3);
%sorted_sigvals = sigvals(inds); % sort by mustar vals
hold on
for ii = 1:length(parnames)
    plot(mustar(ii), sigvals(ii), ...
        'markersize',marksize,'marker',ms,'color', cmap(ii,:), ...
        'linestyle','none')
end
xlabel('\mu^*', 'fontsize', fx)
ylabel('\sigma', 'fontsize', fy)
legend(parnames, 'fontsize',fleg)
title("Morris Plot for K_{plasma}", 'fontsize', ft)
grid on

figure(2)
clf
mustar = tvals_gut(:, 4, 2); 
sigvals = tvals_gut(:, 4, 3);
hold on
for ii = 1:length(parnames)
    plot(mustar(ii), sigvals(ii), ...
        'markersize',marksize,'marker',ms,'color', cmap(ii,:), ...
        'linestyle','none')
end
xlabel('\mu^*', 'fontsize', fx)
ylabel('\sigma', 'fontsize', fy)
legend(parnames, 'fontsize',fleg)
title("Morris Plot for K_{gut}", 'fontsize', ft)
grid on

figure(3)
clf
mustar = tvals_inter(:, 4, 2); 
sigvals = tvals_inter(:, 4, 3);
hold on
for ii = 1:length(parnames)
    plot(mustar(ii), sigvals(ii), ...
        'markersize',marksize,'marker',ms,'color', cmap(ii,:), ...
        'linestyle','none')
end
xlabel('\mu^*', 'fontsize', fx)
ylabel('\sigma', 'fontsize', fy)
legend(parnames, 'fontsize',fleg)
title("Morris Plot for K_{inter}", 'fontsize', ft)
grid on

figure(4)
clf
mustar = tvals_musc(:, 4, 2); 
sigvals = tvals_musc(:, 4, 3);
hold on
for ii = 1:length(parnames)
    plot(mustar(ii), sigvals(ii), ...
        'markersize',marksize,'marker',ms,'color', cmap(ii,:), ...
        'linestyle','none')
end
xlabel('\mu^*', 'fontsize', fx)
ylabel('\sigma', 'fontsize', fy)
legend(parnames, 'fontsize',fleg)
title("Morris Plot for K_{muscle}", 'fontsize', ft)
grid on

%----------------------
% functions used
%----------------------


%% get time vals
function tvals = get_time_vals(parnames, T)
    tvals = zeros(length(parnames), 4, 3); % 1: mu, 2: mu*, 3: sigma
    for ii = 1:length(parnames)
        pname = parnames(ii);
        tvals(ii,:,1) = get_mu(T, pname);
        tvals(ii,:,2) = get_mustar(T, pname);
        tvals(ii,:,3) = get_sigma(T, pname);
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

