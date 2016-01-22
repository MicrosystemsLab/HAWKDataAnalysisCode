function [newXAxis, newYAxis]= MiriamAxes(inputAxes,xySpec)
% MIRIAMAXES  Separate axes from plot. Moves the lines of the axes away
% from the data to put the focus on the data itself. Maintains the font and
% labels from the current plot.
%
% Author: Adam Nekikmken
% email address: adam.nekimken@gmail.com
% January 2016
%
% Syntax: [newXAxis, newYAxis]= MiriamAxes(inputAxes,xySpec) 
%
% Inputs:
%    inputAxes - Handle to axes being changed.
%    xySpec - String specifying which axis(es) to move. 'x', 'y', or 'xy'
%
% Outputs:
%    newXAxis - Handle to the new X axis
%    newYAxis - Handle to the new Y axis
%
% Example: 
%    load examgrades.mat
%    plot(grades)
%    xlabel('Student','FontSize',24)
%    ylabel('Grade','FontSize',24)
%    set(gca,'FontSize',24)
%    xlim([0 120])
%    [newXAxis, newYAxis]= MiriamAxes(gca,'xy')
%
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: GCA 


%------------- BEGIN CODE --------------

% check which axis needs moving
if strcmp(xySpec,'x')
    xoffset=0;
    yoffset=0.05;
elseif strcmp(xySpec,'y')
    xoffset=0.05;
    yoffset=0;
elseif strcmp(xySpec,'xy')
    xoffset=0.05;
    yoffset=0.05;
end

% move current axes inward to make room
oldPosition=get(inputAxes,'Position');
set(inputAxes,'Position',[oldPosition(1)+xoffset oldPosition(2)+yoffset oldPosition(3) oldPosition(4)])
oldylim=ylim;
oldxlim=xlim;
oldFontSize=get(gca,'FontSize');
set(inputAxes,'Visible','off')

% create separate y axis
newYAxis=axes('Position',[oldPosition(1) oldPosition(2)+yoffset 0.0001 oldPosition(4)]);
yLab=get(get(inputAxes,'YLabel'),'String');
ylabel(yLab,'FontSize',oldFontSize)
ylim(oldylim)
set(newYAxis,'FontSize',oldFontSize,'LineWidth',2,'XTick',[],'TickLength',[0.025 0.025])

% create separate x axis
newXAxis=axes('Position',[oldPosition(1)+xoffset oldPosition(2) oldPosition(3) 0.01]);
xLab=get(get(inputAxes,'XLabel'),'String');
xlabel(xLab,'FontSize',oldFontSize)
xlim(oldxlim)
set(newXAxis,'FontSize',oldFontSize,'LineWidth',2,'YTick',[],'TickLength',[0.025 0.025])


%make background white
set(gcf,'Color','w')

end
%------------- END OF CODE --------------