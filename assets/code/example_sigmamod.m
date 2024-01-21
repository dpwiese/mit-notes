%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Daniel Wiese
% 2.153 - Adaptive Control
% Monday 14-April-2014
% example_sigmamod_v1.m
%-----------------------------------------------------------------------------------
% This script simulates and plots the response of an adaptive system with input
% disturbance. We can plot the response of the nominal system without sigmamod or
% disturbance (stable), turn the disturbance on without sigmamod and show
% unboundedness of error (unstable), and then use sigmamod to make stable.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
clc;
close all;
restoredefaultpath;

thismfile = dbstack('-completenames');
thisdir = fileparts(thismfile.file);

cd(thisdir);
addpath(fullfile(fileparts(pwd)));
plotdir = '~/plots';
addpath('~/tools');
s = tf('s');

% Simulation parameters
tsim = 60;
am = -1;
nu = 5;
sigma = 1;
thetastar = -5;

% Initial conditions
ym = 1;
e0 = 5;
thetatilde0 = 5;

%Plotting parameters
AxesLineWidth = 2;
PlotLineWidth = 2;
PlotFontSizeTitle = 16;
PlotFontSizeLab = 16;
PlotFontSizeLegend = 16;
AxesLineColor = [0.3, 0.3, 0.3];
AxesLineStyle = '--';
emin = -10;
emax = 10;
eplotmin = -10;
eplotmax = 10;
ThetaTildePlotmin = -10;
ThetaTildePlotmax = 10;

% Plot the vector field
% Define the error differential equations
f = @(t,Y) [am * Y(1) + Y(2) * (Y(1) + ym) + nu;...
            -Y(1) * (Y(1)+ym) - sigma * (Y(2) + thetastar)];

% Set up a linspace grid over which to determine the direction of the vector Ydot
y1 = linspace(emin, emax, 21);
y2 = linspace(emin, emax, 21);
[x, y] = meshgrid(y1, y2);

% Preallocate the derivatives
edot = zeros(size(x));
phidot = zeros(size(x));

% Solve for the derivatives
t = 0;
for ii = 1:length(y1)
    for jj=1:length(y2)
        Yprime = f(t, [y1(ii); y2(jj)]);
        edot(ii, jj) = Yprime(1);
        phidot(ii, jj) = Yprime(2);
    end
end

% Normalize length of vectors
L = 2 * sqrt(edot.^2 + phidot.^2);

% Simulate the error dynamics in time
sim('model_sigmamod_v1')

% Plot the results
cd(plotdir)

figure(1)
quiver(x, y, edot'./L', phidot'./L', 0, 'color', [0.5, 0.5, 0.5]);
hold on
plot([0, 0], [ThetaTildePlotmin, ThetaTildePlotmax], 'color', [0, 0, 0])
plot([eplotmin,eplotmax], [0, 0], 'color', [0, 0, 0])
plot(eout.signals.values, thetatildeout.signals.values,...
    'linestyle', '-',...
    'color', [0, 0, 0],...
    'linewidth', PlotLineWidth);
plot(eout.signals.values(1), thetatildeout.signals.values(1),...
    'linestyle', 'o',...
    'LineWidth', 2,...
    'MarkerEdgeColor', 'k',...
    'MarkerFaceColor', [0.5, 1, 0.6],...
    'MarkerSize', 10);
plot(eout.signals.values(end), thetatildeout.signals.values(end),...
    'linestyle', 's',...
    'LineWidth', 2,...
    'MarkerEdgeColor', 'k',...
    'MarkerFaceColor', [1, 0.49, 0.63],...
    'MarkerSize', 10);
xlim([eplotmin, eplotmax])
ylim([ThetaTildePlotmin, ThetaTildePlotmax])
daspect([1, 1, 1])
plot_title1 = strcat('$x_{m}=$', sprintf('%0.0f',ym), ', $\nu=$', sprintf('%0.0f', nu));
title(plot_title1, 'interpreter', 'latex', 'FontSize', PlotFontSizeTitle)
xlabel('$e$', 'interpreter', 'latex', 'FontSize', PlotFontSizeLab)
ylabel('$\tilde{\theta}$', 'interpreter', 'latex', 'FontSize', PlotFontSizeLab)
set(gcf, 'Units', 'pixels');
set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0, 0, 10, 6]);
set(gcf, 'PaperPositionMode', 'manual')
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'color',[1, 1, 1])
box on
print('-depsc', '-r600', 'sim_r1nu5sigma1_phase.eps');

figure(2)
subplot(2, 1, 1)
plot(eout.time, eout.signals.values, 'linewidth', PlotLineWidth, 'color', [0, 0, 0])
plot_title1 = strcat('Tracking Error: ', ' $x_{m}=$', sprintf('%0.0f', ym), ', $\nu=$', sprintf('%0.0f', nu));
title(plot_title1, 'interpreter', 'latex', 'FontSize', PlotFontSizeTitle)
xlabel('$t$', 'interpreter', 'latex', 'FontSize', PlotFontSizeLab)
ylabel('$e$', 'interpreter', 'latex', 'FontSize', PlotFontSizeLab)
xlim([0, tsim]);
ylim([-4, 6]);
box on

subplot(2, 1, 2)
plot(thetatildeout.time, thetatildeout.signals.values,...
    'linewidth', PlotLineWidth,...
    'color',[0, 0, 0])
plot_title1 = strcat('Parameter Error');
title(plot_title1, 'interpreter', 'latex', 'FontSize', PlotFontSizeTitle)
xlabel('$t$', 'interpreter', 'latex', 'FontSize', PlotFontSizeLab)
ylabel('$\tilde{\theta}$', 'interpreter', 'latex', 'FontSize', PlotFontSizeLab)
xlim([0, tsim]);
ylim([-40, 5]);
box on
set(gcf, 'Units', 'pixels');
set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0, 0, 10, 6]);
set(gcf, 'PaperPositionMode', 'manual')
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'color',[1, 1, 1]);
print('-depsc', '-r600', 'sim_r1nu5sigma1_tres.eps');

cd(thisdir)
