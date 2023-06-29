% Make plots for data from R simulations
clear all

%% Import simulation data
fprintf('loading data \n')
% old style results
fname1 = "2023-06-29_MealMod_MealOnly_notes-sepmodscripts.csv";
dat1 = readtable(strcat("./results/",fname1));
pars1 = readtable("./results/params_MealMod_notes-sepmeals.csv"); %readtable(strcat("./results/", "params_",fname));

% conc style results
fname2 = "2023-06-29_modeleqnsBaseSS_notes-baseSS.csv";
dat2 = readtable(strcat("./results/", fname2));
pars2 = readtable("./results/params_MealMod_notes-newconc.csv");

%% Make figures
% figure specs
lw = 3;
f.xlab = 16; f.ylab = 16; f.title = 18;
f.leg = 16;
cmap = parula(5);
c1 = cmap(1,:);
c2 = cmap(3,:);
ls1 = '-'; ls2 = '-.';
cgraymap = gray(5);
cgray = cgraymap(3,:);
lwgray = 2; lsgray = '--';
x0 = dat1.time(1); xf = dat1.time(end);

%% Variables fig
figure(1)
clf
nrows=2; ncols=2;
subplot(nrows,ncols,1)
hold on
plot(dat1.time, dat1.amt_gut,'linewidth',lw,'color',c1,'linestyle',ls1)
plot(dat2.time, dat2.amt_gut,'linewidth', lw, 'color', c2, 'linestyle', ls2)
ylabel('M_{Kgut}', 'fontsize',f.ylab)
xlabel('t','fontsize',f.xlab)
title('Gut K Amount', 'fontsize', f.title)
xlim([x0,xf])
grid on

subplot(nrows,ncols,2)
hold on
plot(dat1.time, dat1.amt_plas,'linewidth',lw,'color',c1, 'linestyle',ls1)
plot(dat2.time, dat2.conc_plas * pars2.V_plasma, 'linewidth', lw, 'color', c2, 'linestyle', ls2)
ylabel('M_{Kplas}', 'fontsize', f.ylab)
xlabel('t', 'fontsize', f.xlab)
title('Plasma K Amount', 'fontsize', f.title)
xlim([x0,xf])
grid on

subplot(nrows,ncols,3)
hold on
plot(dat1.time,dat1.amt_inter,'linewidth',lw,'color',c1, 'linestyle',ls1)
plot(dat2.time, dat2.conc_inter * pars2.V_inter, 'linewidth', lw, 'color', c2, 'linestyle', ls2)
ylabel('M_{Kinter}', 'fontsize', f.ylab)
xlabel('t', 'fontsize', f.xlab)
title('Interstitial K Amount', 'fontsize', f.title)
xlim([x0,xf])
grid on

subplot(nrows,ncols,4)
hold on
plot(dat1.time,dat1.amt_muscle,'linewidth',lw,'color',c1, 'linestyle',ls1)
plot(dat2.time, dat2.conc_muscle * pars2.V_muscle, 'linewidth', lw, 'color', c2, 'linestyle', ls2)
ylabel('M_{Kmuscle}', 'fontsize', f.ylab)
xlabel('t', 'fontsize', f.xlab)
title('Muscle K Amount', 'fontsize', f.title)
xlim([x0,xf])
grid on

legend("old version", "conc version")

%% Concentrations
figure(2)
clf
nrows=1; ncols=3;
subplot(nrows,ncols,1)
plot(dat1.time, dat1.amt_plas/pars1.V_plasma,'linewidth',lw,'color',c1, 'linestyle',ls1)
hold on
plot(dat2.time, dat2.conc_plas, 'linewidth', lw, 'color',c2, 'linestyle', ls2)
yline(3.5,'color',cgray,'linestyle',lsgray, 'linewidth', lwgray)
yline(5.0,'color',cgray,'linestyle',lsgray, 'linewidth', lwgray)
ylabel('[K^+]_{plasma}', 'fontsize', f.ylab)
xlabel('t', 'fontsize', f.xlab)
title('Plasma [K^+]', 'fontsize', f.title)
xlim([x0,xf])
grid on

subplot(nrows,ncols,2)
plot(dat1.time,dat1.amt_inter/pars1.V_inter,'linewidth',lw,'color',c1, 'linestyle',ls1)
hold on
plot(dat2.time, dat2.conc_inter, 'linewidth', lw, 'color',c2, 'linestyle', ls2)
yline(3.5,'color',cgray,'linestyle',lsgray, 'linewidth', lwgray)
yline(5.0,'color',cgray,'linestyle',lsgray, 'linewidth', lwgray)
ylabel('[K^+]_{inter}', 'fontsize', f.ylab)
xlabel('t', 'fontsize', f.xlab)
title('Interstitial [K^+]', 'fontsize', f.title)
xlim([x0,xf])
grid on

subplot(nrows,ncols,3)
hold on
plot(dat1.time,dat1.amt_muscle/pars1.V_muscle,'linewidth',lw,'color',c1, 'linestyle',ls1)
hold on
plot(dat2.time, dat2.conc_muscle, 'linewidth', lw, 'color',c2, 'linestyle', ls2)
yline(120,'color',cgray,'linestyle',lsgray, 'linewidth', lwgray)
yline(140,'color',cgray,'linestyle',lsgray, 'linewidth', lwgray)
ylabel('[K^+]_{muscle}', 'fontsize', f.ylab)
xlabel('t', 'fontsize', f.xlab)
title('Muscle [K^+]', 'fontsize', f.title)
xlim([x0,xf])
grid on

legend("old version", "conc version")
