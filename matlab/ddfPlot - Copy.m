function ddfPlot(uniImag,latVect,lonVect,plotData,fileName,gps)
% save the figure with tracks on Google Maps into specified image file 
%
%
%cla(ax);
allLines = copyLines(plotData);
h = figure; 
h_tmp = image(lonVect,latVect(end:-1:1),uniImag);
ax_tmp = get(h_tmp,'Parent');
hold(ax_tmp,'on');
L = length(allLines);
for i = 1:L % each line
    X = allLines{i}.XData;
    Y = allLines{i}.YData;
%     jj = round((X-lonVect(1))/dLon + 1);
%     ii = round((Y-latVect(1))/dLat + 1);
%     plot(ax2,jj,ii,'r-','linewidth',1.5);  
    plot(ax_tmp,X,latVect(1)-(Y-latVect(end)) ,'r-','linewidth',1.5);
end
saveas(h_tmp,fileName,'jpg');
writeGPS2JPG(fileName,gps);
hold(ax_tmp,'off');
close(h);
end

function allLines = copyLines(plotData)
L = length(plotData);
allLines = cell(1,L);
for i = 1:L
    allLines{i}.XData = plotData(i).XData;
    allLines{i}.YData = plotData(i).YData;
end
end