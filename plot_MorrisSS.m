% Use this script to plot the Morris results
clear all;

% Load data 
date2save = "2023-06-29";
notes = "conc";
sim_type = "SS";

% amt_gut
var = "amt_gut"
fname = strcat("./MorrisResults/", date2save, '_MorrisAnalysis',...
            '_type-', sim_type,...
            '_var-', var,...
            "_notes-", notes, ".csv");
Tgut = readtable(fname, 'ReadRowNames',true);

% conc_plas
var = "conc_plas"
fname = strcat("./MorrisResults/", date2save, '_MorrisAnalysis',...
            '_type-', sim_type,...
            '_var-', var,...
            "_notes-", notes, ".csv");
Tplas = readtable(fname,'ReadRowNames',true);

% conc_inter
var = "conc_inter"
fname = strcat("./MorrisResults/", date2save, '_MorrisAnalysis',...
            '_type-', sim_type,...
            '_var-', var,...
            "_notes-", notes, ".csv");
Tint = readtable(fname,'ReadRowNames',true);

% conc_muscle
var = "conc_muscle"
fname = strcat("./MorrisResults/", date2save, '_MorrisAnalysis',...
            '_type-', sim_type,...
            '_var-', var,...
            "_notes-", notes, ".csv");
Tmusc = readtable(fname,'ReadRowNames',true);

%% parameter names list
parnames = ["V_plasma", ...
            "V_inter", ...
            "V_muscle", ...
            "kgut", ...
            "Km", ... 
            "Vmax", ...
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
times = Tplas("time", :);
cmap = turbo(length(parnames));
marksize=25; ms = '.';
fx = 16; fy = 16; fleg = 12; ft = 18;
dx = 0.01; dy = 0.01; % labels
nrows = 2; ncols = 2;
parnames_plt = cell(size(parnames));
for ii = 1:length(parnames)
    parnames_plt{ii} = change_parname(parnames(ii));
end

figure(1)
clf
tpt = 5;
% K gut
subplot(nrows,ncols,1)
mustar = tvals_gut(:, tpt, 2); 
sigvals = tvals_gut(:, tpt, 3);
hold on
for ii = 1:length(parnames)
    plot(mustar(ii), sigvals(ii), ...
        'markersize',marksize,'marker',ms,'color', cmap(ii,:), ...
        'linestyle','none')
    text(mustar(ii) + dx, sigvals(ii) + dy, parnames_plt{ii})
end
xlabel('\mu^*', 'fontsize', fx)
ylabel('\sigma', 'fontsize', fy)
title("Morris Plot for M_{Kgut}", 'fontsize', ft)
grid on

% K plas
subplot(nrows,ncols,2)
mustar = tvals_plas(:, tpt, 2);
%[sorted_mustar, inds] = sort(mustar); 
sigvals = tvals_plas(:, tpt, 3);
%sorted_sigvals = sigvals(inds); % sort by mustar vals
hold on
for ii = 1:length(parnames)
    plot(mustar(ii), sigvals(ii), ...
        'markersize',marksize,'marker',ms,'color', cmap(ii,:), ...
        'linestyle','none')
    text(mustar(ii) + dx, sigvals(ii) + dy, parnames_plt{ii})
end
xlabel('\mu^*', 'fontsize', fx)
ylabel('\sigma', 'fontsize', fy)
title("Morris Plot for [K^+]_{plasma}", 'fontsize', ft)
grid on


% K inter
subplot(nrows,ncols,3)
mustar = tvals_inter(:, tpt, 2); 
sigvals = tvals_inter(:, tpt, 3);
hold on
for ii = 1:length(parnames)
    plot(mustar(ii), sigvals(ii), ...
        'markersize',marksize,'marker',ms,'color', cmap(ii,:), ...
        'linestyle','none')
    text(mustar(ii) + dx, sigvals(ii) + dy, parnames_plt{ii})
end
xlabel('\mu^*', 'fontsize', fx)
ylabel('\sigma', 'fontsize', fy)
title("Morris Plot for [K^+]_{inter}", 'fontsize', ft)
grid on

% K muscle
subplot(nrows,ncols,4)
mustar = tvals_musc(:, tpt, 2); 
sigvals = tvals_musc(:, tpt, 3);
hold on
for ii = 1:length(parnames)
    plot(mustar(ii), sigvals(ii), ...
        'markersize',marksize,'marker',ms,'color', cmap(ii,:), ...
        'linestyle','none')
    text(mustar(ii) + dx, sigvals(ii) + dy, parnames_plt{ii})
end
xlabel('\mu^*', 'fontsize', fx)
ylabel('\sigma', 'fontsize', fy)
title("Morris Plot for [K^+]_{muscle}", 'fontsize', ft)
grid on

legend(parnames_plt, 'fontsize',fleg)

temp = strcat('times.time', num2str(tpt));
tval = eval(temp);
sgtitle(['SS Morris Analysis, time = ', num2str(tval)])
%sgtitle('SS Morris Analysis')


figure(2)
clf
tpt = 3;
% K gut
subplot(nrows,ncols,1)
mustar = tvals_gut(:, tpt, 2); 
sigvals = tvals_gut(:, tpt, 3);
hold on
for ii = 1:length(parnames)
    plot(mustar(ii), sigvals(ii), ...
        'markersize',marksize,'marker',ms,'color', cmap(ii,:), ...
        'linestyle','none')
    text(mustar(ii) + dx, sigvals(ii) + dy, parnames_plt{ii})
end
xlabel('\mu^*', 'fontsize', fx)
ylabel('\sigma', 'fontsize', fy)
title("Morris Plot for M_{Kgut}", 'fontsize', ft)
grid on

% K plas
subplot(nrows,ncols,2)
mustar = tvals_plas(:, tpt, 2);
%[sorted_mustar, inds] = sort(mustar); 
sigvals = tvals_plas(:, tpt, 3);
%sorted_sigvals = sigvals(inds); % sort by mustar vals
hold on
for ii = 1:length(parnames)
    plot(mustar(ii), sigvals(ii), ...
        'markersize',marksize,'marker',ms,'color', cmap(ii,:), ...
        'linestyle','none')
    text(mustar(ii) + dx, sigvals(ii) + dy, parnames_plt{ii})
end
xlabel('\mu^*', 'fontsize', fx)
ylabel('\sigma', 'fontsize', fy)
title("Morris Plot for [K^+]_{plasma}", 'fontsize', ft)
grid on


% K inter
subplot(nrows,ncols,3)
mustar = tvals_inter(:, tpt, 2); 
sigvals = tvals_inter(:, tpt, 3);
hold on
for ii = 1:length(parnames)
    plot(mustar(ii), sigvals(ii), ...
        'markersize',marksize,'marker',ms,'color', cmap(ii,:), ...
        'linestyle','none')
    text(mustar(ii) + dx, sigvals(ii) + dy, parnames_plt{ii})
end
xlabel('\mu^*', 'fontsize', fx)
ylabel('\sigma', 'fontsize', fy)
title("Morris Plot for [K^+]_{inter}", 'fontsize', ft)
grid on

% K muscle
subplot(nrows,ncols,4)
mustar = tvals_musc(:, tpt, 2); 
sigvals = tvals_musc(:, tpt, 3);
hold on
for ii = 1:length(parnames)
    plot(mustar(ii), sigvals(ii), ...
        'markersize',marksize,'marker',ms,'color', cmap(ii,:), ...
        'linestyle','none')
    text(mustar(ii) + dx, sigvals(ii) + dy, parnames_plt{ii})
end
xlabel('\mu^*', 'fontsize', fx)
ylabel('\sigma', 'fontsize', fy)
title("Morris Plot for [K^+]_{muscle}", 'fontsize', ft)
grid on

legend(parnames_plt, 'fontsize',fleg)

temp = strcat('times.time', num2str(tpt));
tval = eval(temp);
sgtitle(['SS Morris Analysis, time = ', num2str(tval)])
%sgtitle("SS Morris Analysis")



%----------------------
% functions used
%----------------------


%% get time vals
function tvals = get_time_vals(parnames, T)
    ntimes = size(T.Properties.VariableNames, 2);
    tvals = zeros(length(parnames), ntimes, 3); % 1: mu, 2: mu*, 3: sigma
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
    nt = size(T.Properties.VariableNames, 2);
    vals = T(nm, :);
    sig_vals = zeros(nt,1);
    for ii = 1:nt
        temp = strcat('vals.time', num2str(ii));
        sig_vals(ii) = eval(temp);
    end
end

%% get mu star values
function mus_vals = get_mustar(T, pname)
    % Input
    %   T - table
    %   pname - parameter name
    nm = strcat('mu.star_', pname);
    nt = size(T.Properties.VariableNames, 2);
    vals = T(nm, :);
    mus_vals = zeros(nt,1);
    for ii = 1:nt
        temp = strcat('vals.time', num2str(ii));
        mus_vals(ii) = eval(temp);
    end
end

%% get mu values
function mu_vals = get_mu(T, pname)
    % Input
    %   T - table
    %   pname - parameter name
    nm = strcat('mu_', pname);
    nt = size(T.Properties.VariableNames, 2);
    vals = T(nm, :);
    mu_vals = zeros(nt, 1);
    for ii = 1:nt
        temp = strcat('vals.time', num2str(ii));
        mu_vals(ii) = eval(temp);
    end
end

%% plot parnames
function pnew = change_parname(pname)
    if strcmp(pname, "kgut")
        pnew = "k_{gut}";
    elseif strcmp(pname, "V_plasma")
        pnew = "V_{plasma}";
    elseif strcmp(pname, "V_inter")
        pnew = "V_{inter}";
    elseif strcmp(pname, "V_muscle")
        pnew = "V_{muscle}";
    elseif strcmp(pname, "m_K_ALDO")
        pnew = "m_K^{ALDO}";
    elseif strcmp(pname, "ALD_eq")
        pnew = "ALD_{eq}";
    elseif strcmp(pname, "P_ECF")
        pnew = "P_{ECF}";
    elseif strcmp(pname, "dtKsec_eq")
        pnew = "dt_{Ksec}^{eq}";
    elseif strcmp(pname, "A_dtKsec")
        pnew = "A_{dtKsec}";
    elseif strcmp(pname, "B_dtKsec")
        pnew = "B_{dtKsec}";
    elseif strcmp(pname, "cdKsec_eq")
        pnew = "cd_{Ksec}^{eq}";
    elseif strcmp(pname, "A_cdKsec")
        pnew = "A_{cdKsec}";
    elseif strcmp(pname, "B_cdKsec")
        pnew = "B_{cdKsec}";
    elseif strcmp(pname, "A_cdKreab")
        pnew = "A_{cdKreab}";
    elseif strcmp(pname, "A_insulin")
        pnew = "A_{insulin}";
    elseif strcmp(pname, "B_insulin")
        pnew = "B_{insulin}";
    else
        pnew = pname;
    end
end
