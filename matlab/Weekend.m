% Scenario 3: the traffic is not busy (weekend or weekday)
% Probability setting for different trajectories and directions.
% N: 0.08, N_NE: 0.08, N_SW: 0.08
% NE: 0.08, NE_N: 0.08, NE_S: 0.08
% S: 0.08, S_NE: 0.08, S_SW: 0.09
% SW: 0.09, SW_N: 0.09, SW_S: 0.09

tic;
scale = 0.01;
epsilon = 0.00000001;

ii=1;
structData=struct;
structData.X=zeros(400,2500);
structData.Y=zeros(400,1);
for ii=1:1:400
    a=rand;
    r = ceil(1000*rand); % pich the rth sample from each pre-generated track dataset
    imgData = zeros(50,50);
    if (a<=0.08)
%         [xx,yy,k]=N2();
%         GT{ii}.label = 'N';
%         structData.Y(ii)=6;
        structData.Y(ii)=6;
        xx =  handles.similatedData.N.GT{r}.x;
        yy =  handles.similatedData.N.GT{r}.y;
        GT{ii}.label = handles.similatedData.N.GT{r}.label;
        a = find(xx>0);
        plot(handles.axes_traffic,xx(1:a(end)),yy(1:a(end)),'y'); drawnow;   
    elseif (a>0.08)&&(a<=0.16)
%         [xx,yy,k]=N_NE2();
%         GT{ii}.label = 'N_NE';
%         structData.Y(ii)=1;
        xx =  handles.similatedData.N_NE.GT{r}.x;
        yy =  handles.similatedData.N_NE.GT{r}.y;
        GT{ii}.label = handles.similatedData.N_NE.GT{r}.label;        
        structData.Y(ii)=1;
        a = find(xx>0);
        plot(handles.axes_traffic,xx(1:a(end)),yy(1:a(end)),'g'); drawnow;  
    elseif (a>0.16)&&(a<=0.24)
%         [xx,yy,k]=N_SW2();
%         GT{ii}.label = 'N_SW';
%         structData.Y(ii)=2;
        xx =  handles.similatedData.N_SW.GT{r}.x;
        yy =  handles.similatedData.N_SW.GT{r}.y;
        GT{ii}.label = handles.similatedData.N_SW.GT{r}.label;        
        structData.Y(ii)=2;
        a = find(xx>0);
        plot(handles.axes_traffic,xx(1:a(end)),yy(1:a(end)),'g'); drawnow; 
    elseif (a>0.24)&&(a<=0.32)
%         [xx,yy,k]=NE2();
%         GT{ii}.label = 'NE';
%         structData.Y(ii)=8;
        xx =  handles.similatedData.NE.GT{r}.x;
        yy =  handles.similatedData.NE.GT{r}.y;
        GT{ii}.label = handles.similatedData.NE.GT{r}.label;        
        structData.Y(ii)=8;
        a = find(xx>0);
        plot(handles.axes_traffic,xx(1:a(end)),yy(1:a(end)),'b'); drawnow;
    elseif (a>0.32)&&(a<=0.4)
%         [xx,yy,k]=NE_N2();
%         GT{ii}.label = 'NE_N';
%         structData.Y(ii)=3;
        xx =  handles.similatedData.NE_N.GT{r}.x;
        yy =  handles.similatedData.NE_N.GT{r}.y;
        GT{ii}.label = handles.similatedData.NE_N.GT{r}.label;        
        structData.Y(ii)=3;
        a = find(xx>0);
        plot(handles.axes_traffic,xx(1:a(end)),yy(1:a(end)),'r'); drawnow;    
    elseif (a>0.4)&&(a<=0.48)
%         [xx,yy,k]=NE_S2();
%         GT{ii}.label = 'NE_S';
%         structData.Y(ii)=4;
        xx =  handles.similatedData.NE_S.GT{r}.x;
        yy =  handles.similatedData.NE_S.GT{r}.y;
        GT{ii}.label = handles.similatedData.NE_S.GT{r}.label;        
        structData.Y(ii)=4;
        a = find(xx>0);
        plot(handles.axes_traffic,xx(1:a(end)),yy(1:a(end)),'r'); drawnow;
    elseif (a>0.48)&&(a<=0.56)
%         [xx,yy,k]=S2();
%         GT{ii}.label = 'S';
%         structData.Y(ii)=5;
        xx =  handles.similatedData.S.GT{r}.x;
        yy =  handles.similatedData.S.GT{r}.y;
        GT{ii}.label = handles.similatedData.S.GT{r}.label;        
        structData.Y(ii)=5;
        a = find(xx>0);
        plot(handles.axes_traffic,xx(1:a(end)),yy(1:a(end)),'g'); drawnow;
    elseif (a>0.56)&&(a<=0.64)
%         [xx,yy,k]=S_NE2();
%         GT{ii}.label = 'S_NE';
%         structData.Y(ii)=9;
        xx =  handles.similatedData.S_NE.GT{r}.x;
        yy =  handles.similatedData.S_NE.GT{r}.y;
        GT{ii}.label = handles.similatedData.S_NE.GT{r}.label;
        structData.Y(ii)=9;
        a = find(xx>0);
        plot(handles.axes_traffic,xx(1:a(end)),yy(1:a(end)),'b'); drawnow;
    elseif (a>0.64)&&(a<=0.73)
%         [xx,yy,k]=S_SW2();
%         GT{ii}.label = 'S_SW';
%         structData.Y(ii)=10;
        xx =  handles.similatedData.S_SW.GT{r}.x;
        yy =  handles.similatedData.S_SW.GT{r}.y;
        GT{ii}.label = handles.similatedData.S_SW.GT{r}.label;
        structData.Y(ii)=10;
        a = find(xx>0);
        plot(handles.axes_traffic,xx(1:a(end)),yy(1:a(end)),'b'); drawnow;
    elseif (a>0.73)&&(a<=0.82)
%         [xx,yy,k]=SW2();
%         GT{ii}.label = 'SW';
%         structData.Y(ii)=7;
        xx =  handles.similatedData.SW.GT{r}.x;
        yy =  handles.similatedData.SW.GT{r}.y;
        GT{ii}.label = handles.similatedData.SW.GT{r}.label;
        structData.Y(ii)=7;
        a = find(xx>0);
        plot(handles.axes_traffic,xx(1:a(end)),yy(1:a(end)),'r'); drawnow;   
    elseif (a>0.82)&&(a<=0.91)
%         [xx,yy,k]=SW_N2();
%         GT{ii}.label = 'SW_N';
%         structData.Y(ii)=11;
        xx =  handles.similatedData.SW_N.GT{r}.x;
        yy =  handles.similatedData.SW_N.GT{r}.y;
        GT{ii}.label = handles.similatedData.SW_N.GT{r}.label;
        structData.Y(ii)=11;
        a = find(xx>0);
        plot(handles.axes_traffic,xx(1:a(end)),yy(1:a(end)),'y'); drawnow;   
    else
%         [xx,yy,k]=SW_S2();
%         GT{ii}.label = 'SW_S';
%         structData.Y(ii)=12;
        xx =  handles.similatedData.SW_S.GT{r}.x;
        yy =  handles.similatedData.SW_S.GT{r}.y;
        GT{ii}.label = handles.similatedData.SW_S.GT{r}.label;
        structData.Y(ii)=12;
        a = find(xx>0);
        plot(handles.axes_traffic,xx(1:a(end)),yy(1:a(end)),'y'); drawnow;
    end
    
    GT{ii}.x = xx;
    GT{ii}.y = yy;
    for kk=1:1:200
            px = ceil(xx(kk)*scale+epsilon);
            py = ceil(yy(kk)*scale+epsilon);
            if ~(px==1 && py==1)
                imgData(py,px) = 1;
            end        
    end
    structData.X(ii,:)=imgData(:)';    
    ii = ii+1;    
end

save .\working\structData.mat structData;
save .\working\track_GT.mat GT;

toc;