% Make plots for data from R simulations
clear all

%% Import simulation data
fprintf('loading data \n')
fname = "2023-06-23_MealSim_Kin-35_doIns-1_notes-Meal+KCl.csv";

dat = readtable(strcat("./results/",fname));
pars = readtable(strcat("./results/", "params_",fname));

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
x0 = dat.time(1); xf = dat.time(end);

%% Variables fig
figure(1)
clf
nrows=2; ncols=2;
subplot(nrows,ncols,1)
hold on
plot(dat.time, dat.amt_gut,'linewidth',lw,'color',c1,'linestyle',ls1)
ylabel('M_{Kgut}', 'fontsize',f.ylab)
xlabel('t','fontsize',f.xlab)
title('Gut K Amount', 'fontsize', f.title)
xlim([x0,xf])
grid on

subplot(nrows,ncols,2)
plot(dat.time, dat.amt_plas,'linewidth',lw,'color',c1, 'linestyle',ls1)
ylabel('M_{Kplas}', 'fontsize', f.ylab)
xlabel('t', 'fontsize', f.xlab)
title('Plasma K Amount', 'fontsize', f.title)
xlim([x0,xf])
grid on

subplot(nrows,ncols,3)
plot(dat.time,dat.amt_inter,'linewidth',lw,'color',c1, 'linestyle',ls1)
ylabel('M_{Kinter}', 'fontsize', f.ylab)
xlabel('t', 'fontsize', f.xlab)
title('Interstitial K Amount', 'fontsize', f.title)
xlim([x0,xf])
grid on

subplot(nrows,ncols,4)
hold on
plot(dat.time,dat.amt_muscle,'linewidth',lw,'color',c1, 'linestyle',ls1)
ylabel('M_{Kmuscle}', 'fontsize', f.ylab)
xlabel('t', 'fontsize', f.xlab)
title('Muscle K Amount', 'fontsize', f.title)
xlim([x0,xf])
grid on

%% Concentrations
figure(2)
clf
nrows=1; ncols=3;
subplot(nrows,ncols,1)
plot(dat.time, dat.amt_plas/pars.V_plasma,'linewidth',lw,'color',c1, 'linestyle',ls1)
hold on
yline(3.5,'color',cgray,'linestyle',lsgray, 'linewidth', lwgray)
yline(5.0,'color',cgray,'linestyle',lsgray, 'linewidth', lwgray)
ylabel('[K^+]_{plasma}', 'fontsize', f.ylab)
xlabel('t', 'fontsize', f.xlab)
title('Plasma [K^+]', 'fontsize', f.title)
xlim([x0,xf])
grid on

subplot(nrows,ncols,2)
plot(dat.time,dat.amt_inter/pars.V_inter,'linewidth',lw,'color',c1, 'linestyle',ls1)
hold on
yline(3.5,'color',cgray,'linestyle',lsgray, 'linewidth', lwgray)
yline(5.0,'color',cgray,'linestyle',lsgray, 'linewidth', lwgray)
ylabel('[K^+]_{inter}', 'fontsize', f.ylab)
xlabel('t', 'fontsize', f.xlab)
title('Interstitial [K^+]', 'fontsize', f.title)
xlim([x0,xf])
grid on

subplot(nrows,ncols,3)
hold on
plot(dat.time,dat.amt_muscle/pars.V_muscle,'linewidth',lw,'color',c1, 'linestyle',ls1)
hold on
yline(120,'color',cgray,'linestyle',lsgray, 'linewidth', lwgray)
yline(140,'color',cgray,'linestyle',lsgray, 'linewidth', lwgray)
ylabel('[K^+]_{muscle}', 'fontsize', f.ylab)
xlabel('t', 'fontsize', f.xlab)
title('Muscle [K^+]', 'fontsize', f.title)
xlim([x0,xf])
grid on
