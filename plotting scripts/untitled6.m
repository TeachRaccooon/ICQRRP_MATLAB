hold on;
bar1 = bar(1, 100, 'FaceColor', 'white');
bar2 = bar(2, 50, 'FaceColor', 'white');
% Keep an array of the plots so that none of the hatchfill2 lines appear in the legend
bars = [bar1, bar2];
% Hatch the two bars with a texture
hatchfill2(bar1(1), 'cross', 'HatchAngle', 45, 'HatchDensity', 60, 'HatchColor', 'black');
hatchfill2(bar2(1), 'single', 'HatchAngle', 45, 'HatchDensity', 40, 'HatchColor', 'black');
% Draw the legend
legendData = {'Bar #1', 'Bar #2'};
[legend_h, object_h, plot_h, text_str] = legendflex(bars, legendData, 'Padding', [2, 2, 10], 'FontSize', 18, 'Location', 'NorthEast');
% object_h(1) is the first bar's text
% object_h(2) is the second bar's text
% object_h(3) is the first bar's patch
% object_h(4) is the second bar's patch
%
% Set the two patches within the legend
hatchfill2(object_h(3), 'cross', 'HatchAngle', 45, 'HatchDensity', 60/4, 'HatchColor', 'black');
hatchfill2(object_h(4), 'single', 'HatchAngle', 45, 'HatchDensity', 40/4, 'HatchColor', 'black');
% Some extra formatting to make it pretty :)
set(gca, 'FontSize', 18);
set(gca, 'XMinorTick','on', 'XMinorGrid','on', 'YMinorTick','on', 'YMinorGrid','on');
xlim([0, 3]);
ylim([0, 110]);