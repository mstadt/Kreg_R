% Make plots for data from R simulations
clear all

%% Import simulation data
fprintf('loading data \n')
% Meal + KCl
fname1 = "2023-06-29_MealMod_MealKCl_notes-changeins.csv";
dat1   = readtable(strcat("./results/",fname1));
pars1  = readtable("./results/params_MealMod_notes-changeins.csv"); %readtable(strcat("./results/", "params_",fname1));
lab1   = "Meal + KCl";

% KCl only
fname2 = "2023-06-29_MealMod_KClOnly_notes-changeins.csv";
dat2   = readtable(strcat("./results/",fname2));
pars2  = pars1 ; %readtable(strcat("./results/", "params_",fname2));
lab2   = 'KCl Only';

% Meal only
fname3 = "2023-06-29_MealMod_MealOnly_notes-changeins.csv";
dat3   = readtable(strcat("./results/",fname3));
pars3  = pars1; %readtable(strcat("./results/", "params_",fname3));
lab3   = 'Meal Only';

%% Make figures
tshift = 460; % set to 460 if doing from separate model scripts, 0 if from the driver_meal script
% figure specs
lw = 3;
f.xlab = 16; f.ylab = 16; f.title = 18;
f.leg = 16;
cmap = parula(6);
c1 = cmap(1,:);
c2 = cmap(3,:);
c3 = cmap(5,:);
ls1 = '-'; ls2 = '-.'; ls3 = '--';
cgraymap = gray(5);
cgray = cgraymap(3,:);
lwgray = 2; lsgray = '--';
x0 = dat1.time(1) - tshift; xf = dat1.time(end) - tshift;
leglabs = {lab1, lab2, lab3};

fprintf('making figs \n')
%% Variables fig
figure(1)
clf
nrows=2; ncols=2;
subplot(nrows,ncols,1)
hold on
plot(dat1.time - tshift, dat1.amt_gut,'linewidth',lw,'color',c1,'linestyle',ls1)
plot(dat2.time - tshift, dat2.amt_gut,'linewidth',lw,'color',c2,'linestyle',ls2)
plot(dat3.time - tshift, dat3.amt_gut,'linewidth',lw,'color',c3,'linestyle',ls3)
ylabel('M_{Kgut}', 'fontsize',f.ylab)
xlabel('t','fontsize',f.xlab)
title('Gut K Amount', 'fontsize', f.title)
xlim([x0,xf])
grid on

subplot(nrows,ncols,2)
hold on
plot(dat1.time - tshift, dat1.amt_plas,'linewidth',lw,'color',c1, 'linestyle',ls1)
plot(dat2.time - tshift, dat2.amt_plas,'linewidth',lw,'color',c2, 'linestyle',ls2)
plot(dat3.time - tshift, dat3.amt_plas,'linewidth',lw,'color',c3, 'linestyle',ls3)
ylabel('M_{Kplas}', 'fontsize', f.ylab)
xlabel('t', 'fontsize', f.xlab)
title('Plasma K Amount', 'fontsize', f.title)
xlim([x0,xf])
grid on

subplot(nrows,ncols,3)
hold on
plot(dat1.time - tshift,dat1.amt_inter,'linewidth',lw,'color',c1, 'linestyle',ls1)
plot(dat2.time - tshift,dat2.amt_inter,'linewidth',lw,'color',c2, 'linestyle',ls2)
plot(dat3.time - tshift,dat3.amt_inter,'linewidth',lw,'color',c3, 'linestyle',ls3)
ylabel('M_{Kinter}', 'fontsize', f.ylab)
xlabel('t', 'fontsize', f.xlab)
title('Interstitial K Amount', 'fontsize', f.title)
xlim([x0,xf])
grid on

subplot(nrows,ncols,4)
hold on
plot(dat1.time - tshift,dat1.amt_muscle,'linewidth',lw,'color',c1, 'linestyle',ls1)
plot(dat2.time - tshift,dat2.amt_muscle,'linewidth',lw,'color',c2, 'linestyle',ls2)
plot(dat3.time - tshift,dat3.amt_muscle,'linewidth',lw,'color',c3, 'linestyle',ls3)
ylabel('M_{Kmuscle}', 'fontsize', f.ylab)
xlabel('t', 'fontsize', f.xlab)
title('Muscle K Amount', 'fontsize', f.title)
xlim([x0,xf])
grid on

legend(leglabs, 'fontsize', f.leg)

%% Concentrations
figure(2)
clf
nrows=1; ncols=3;
subplot(nrows,ncols,1)
hold on
plot(dat1.time - tshift, dat1.amt_plas/pars1.V_plasma,'linewidth',lw,'color',c1, 'linestyle',ls1)
plot(dat2.time - tshift, dat2.amt_plas/pars2.V_plasma,'linewidth',lw,'color',c2, 'linestyle',ls2)
plot(dat3.time - tshift, dat3.amt_plas/pars3.V_plasma,'linewidth',lw,'color',c3, 'linestyle',ls3)
% load PrestonData
PresDat = load('./PrestonData/23-Jun-2023_PrestonData.mat');
markersize=15;
errorbar(PresDat.time_serum, PresDat.MealKCL_serum_scaled, PresDat.MealKCL_serum_err,'.', 'markersize', markersize,'color',c1)
plot(PresDat.time_serum, PresDat.MealKCL_serum_scaled, '.', 'markersize', markersize, 'color', c1)
errorbar(PresDat.time_serum, PresDat.KCL_serum_scaled, PresDat.KCL_serum_err,'.', 'markersize', markersize,'color',c2)
plot(PresDat.time_serum, PresDat.KCL_serum_scaled, '.', 'markersize', markersize, 'color', c2)
errorbar(PresDat.time_serum, PresDat.Meal_serum_scaled, PresDat.Meal_serum_err,'.', 'markersize', markersize,'color',c3)
plot(PresDat.time_serum, PresDat.Meal_serum_scaled, '.', 'markersize', markersize, 'color', c3)
yline(3.5,'color',cgray,'linestyle',lsgray, 'linewidth', lwgray)
yline(5.0,'color',cgray,'linestyle',lsgray, 'linewidth', lwgray)
ylabel('[K^+]_{plasma}', 'fontsize', f.ylab)
xlabel('t', 'fontsize', f.xlab)
title('Plasma [K^+]', 'fontsize', f.title)
xlim([x0,xf])
grid on

subplot(nrows,ncols,2)
hold on
plot(dat1.time - tshift,dat1.amt_inter/pars1.V_inter,'linewidth',lw,'color',c1, 'linestyle',ls1)
plot(dat2.time - tshift,dat2.amt_inter/pars2.V_inter,'linewidth',lw,'color',c2, 'linestyle',ls2)
plot(dat3.time - tshift,dat3.amt_inter/pars3.V_inter,'linewidth',lw,'color',c3, 'linestyle',ls3)
yline(3.5,'color',cgray,'linestyle',lsgray, 'linewidth', lwgray)
yline(5.0,'color',cgray,'linestyle',lsgray, 'linewidth', lwgray)
ylabel('[K^+]_{inter}', 'fontsize', f.ylab)
xlabel('t', 'fontsize', f.xlab)
title('Interstitial [K^+]', 'fontsize', f.title)
xlim([x0,xf])
grid on

subplot(nrows,ncols,3)
hold on
plot(dat1.time - tshift,dat1.amt_muscle/pars1.V_muscle,'linewidth',lw,'color',c1, 'linestyle',ls1)
plot(dat2.time - tshift,dat2.amt_muscle/pars2.V_muscle,'linewidth',lw,'color',c2, 'linestyle',ls2)
plot(dat3.time - tshift,dat3.amt_muscle/pars3.V_muscle,'linewidth',lw,'color',c3, 'linestyle',ls3)
hold on
yline(120,'color',cgray,'linestyle',lsgray, 'linewidth', lwgray)
yline(140,'color',cgray,'linestyle',lsgray, 'linewidth', lwgray)
ylabel('[K^+]_{muscle}', 'fontsize', f.ylab)
xlabel('t', 'fontsize', f.xlab)
title('Muscle [K^+]', 'fontsize', f.title)
xlim([x0,xf])
grid on

legend(leglabs, 'fontsize', f.leg)