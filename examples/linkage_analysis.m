function linkage_analysis
addpath ../core
global ht linktype

linktype=1; % fourbar with 

figure(10); gcf; clf;
select_button=uicontrol('Parent',10,'Style','popupmenu','String',...
    {'fourbar (position analysis)';'fourbar (pva analysis)';...
    'crank-slider';'pantograph'; 'jansen'; ...
    'pantograph w/ hoeken ';},...
    'Units','normalized','Position',[0.125 0.875 0.2 0.1],'Visible','on');
% select_button=uicontrol('Parent',10,'Style','popupmenu','String',...
%     {'fourbar w/ coupler';'jansen';'pantograph'; ...
%     'fourbar w/ pantograph by A. Ward'; 'crank-slider'; ...
%     'inverted crank-slider'; ''; ''; ''; 'fourbar w/ coupler'},...
%     'Units','normalized','Position',[0.125 0.875 0.2 0.1],'Visible','on');
select_button.Callback = @select_linkage;

ax1=subplot(1,2,1); 
pos = get(ax1,'Position');
un = get(ax1,'Units');
delete(ax1)
ht = uitable('Units',un,'Position',pos);

% select the linkage
select_linkage(select_button);

% update the plot on right
% update_button=uicontrol('Parent',10,'Style','pushbutton','String','->',...
%     'Units','normalized','Position',[0.5 0.5 0.05 0.03],'Visible','on');
% update_button.Callback = @update_plot;
% 
% update_plot(update_button);

% analyze the linkage
analyze_button=uicontrol('Parent',10,'Style','pushbutton','String','Analyze',...
    'Units','normalized','Position',[0.8 0.9 0.1 0.05],'Visible','on');
analyze_button.Callback = @analyze;


function select_linkage(src, event)
global linktype ht
linktype=get(src,'Value');
switch linktype   
  case 1
%     example01_position_analysis(a,b,c,d,APlen,BAP,w2,simTime);

    ColumnName={'variable', 'value', 'units'};
        
    data={  'a', 1.36, 'm';
            'b', 10, 'm';
            'c', 10, 'm';
            'd', 15, 'm';
            'AP', 20, 'm';
            'BAP', 0, 'degrees';
            'config', 1, 'open=1';
            'omega2', -2, 'rad/s';
            'simTime', 1, 's'};
    ht.Data=data;
    ht.ColumnName=ColumnName;    
    ht.ColumnEditable = [false, true, false];  
  case 2
%     example13_hoekens(a,b,c,d,APlen, BAP, theta2, omega2,alpha2, lnk_rho,rPA, FPAx, FPAy,simTime)
    
    ColumnName={'variable', 'value', 'units'};
        
    data={  'a', 10/100, 'm';
            'b', 25/100, 'm';
            'c', 25/100, 'm';
            'd', 20/100, 'm';
            'APlen', 50/100, 'm';
            'BAP', 0, 'degrees';
            'omega2', -2, 'rad/s';
            'alpha2', 1, 'rad/s^2';
            'simTime', 1, 's';
            'material density', 1190, 'kg/m^3';
            'link width', 0.013, 'm';
            'link thickness', 0.00475, 'm';
            'F3x', 500, 'N';
            'F3y', 0, 'N'};
    ht.Data=data;
    ht.ColumnName=ColumnName;    
    ht.ColumnEditable = [false, true, false];
  case 3

%     example05_crank_slider(a,b,c,w2,cfg, simTime);
    
    ColumnName={'variable', 'value', 'units'};
        
    data={  'a', 40, 'cm';
            'b', 120, 'cm';
            'c', 80, 'cm';
            'omega2', 1, 'rad/s';
            'config', 1, 'open=1';
            'simTime', 1, 's'};
    ht.Data=data;
    ht.ColumnName=ColumnName;    
    ht.ColumnEditable = [false, true, false];        
case 4
        %     example08_pantograph(az, ab, de, yz, wAZ, aAZ)
    
    ColumnName={'variable', 'value', 'units'};
        
    data={  'az', 10, 'cm';
            'ab', 40, 'cm';
            'de', 40, 'cm';
            'yz', 54, 'cm';
            'simTime', 1, 's';
            'omegaAZ', 1, 'rad/s';
            'alphaAZ', 0, 'rad/s^2';};
    ht.Data=data;
    ht.ColumnName=ColumnName;    
    ht.ColumnEditable = [false, true, false];  
case 5
%     example12_jansen(za, ab, by, zy, ac, yc, yd, bd, ce, de, ef, cf, wAZ)
    ColumnName={'variable', 'value', 'units'};
%     ColumnName={'endpoints', 'length (m)', 'theta (rad)','omega (rad/s)',  ...
%             'alpha(rad/s^2)',  'mass (kg)',  ...
%             'moi(kgm^2)', 'torque(Nm)',  'force_x(Nm)', 'force_y(Nm)', 'rF(m)'};
    data={  'AZ', 15/100, 'm'; % crank
            'omegaAZ', 1, 'rad/s';
            'BA', 50/100, 'm';
            'BY',41.5/100,'m';
            'YZ',sqrt(38^2+7.8^2)/100, 'm';
            'thetaYZ', 190, 'radians'
            'AC',61.9/100, 'm';
            'YC',39.3/100, 'm';
            'YD',40.1/100,'m';
            'BD',55.8/100, 'm';
            'CE',36.7/100, 'm';
            'DE',39.4/100, 'm';
            'EF',65.7/100, 'm';
            'CF',49/100, 'm';
            'FFx', 0, 'N';
            'FFy', 0, 'N';
            'link density', 1190, 'kg/m^3';
            'link thickness', 0.00476, 'm';
            'link width', 0.013, 'm';
            'simTime', 1, 's';};
    ht.Data=data;
    ht.ColumnName=ColumnName;    
    ht.ColumnEditable = [false, true, false];  
  case 6
    ColumnName={'variable', 'value', 'units'};
%     ColumnName={'endpoints', 'length (m)', 'theta (rad)','omega (rad/s)',  ...
%             'alpha(rad/s^2)',  'mass (kg)',  ...
%             'moi(kgm^2)', 'torque(Nm)',  'force_x(Nm)', 'force_y(Nm)', 'rF(m)'};
    data={  'AZ', 15, 'm'; % crank
            'omegaAZ', 1, 'rad/s';
            'BA', 50, 'm';
            'BY',41.5,'m';
            'YZ',sqrt(38^2+7.8^2), 'm';
            'thetaYZ', 190, 'degrees'
            'AC',61.9, 'm';
            'YC',39.3, 'm';
            'YD',40.1,'m';
            'BD',55.8, 'm';
            'CE',36.7, 'm';
            'DE',39.4, 'm';
            'EF',65.7, 'm';
            'CF',49, 'm';};
    ht.Data=data;
    ht.ColumnName=ColumnName;    
    ht.ColumnEditable = [false, true, false];     
    
  otherwise
end 

update_plot;


function update_plot(src, event)
global ht linktype
subplot(1,2,2);
cla;
box on;

switch linktype   
  case 1
    [img, map, alphadata]=imread('../doc/fourbar.png');
    image(img, 'alphadata', alphadata);
    axis image;
    axis off; 
  case 2
    [img, map, alphadata]=imread('../doc/fourbar.png');
    image(img, 'alphadata', alphadata);
    axis image;
    axis off;   
  case 3
    [img, map, alphadata]=imread('../doc/crankslider.png');
    image(img, 'alphadata', alphadata);
    axis image;
    axis off;    
  case 4
    [img, map, alphadata]=imread('../doc/sylvester_pantograph.png');
    image(img, 'alphadata', alphadata);
    axis image;
    axis off;   
  case 5
    [img, map, alphadata]=imread('../doc/jansen.png');
    image(img, 'alphadata', alphadata);
    axis image;
    axis off;  
  case 6
    [img, map, alphadata]=imread('../doc/pantograph_with_hoeken.png');
    image(img, 'alphadata', alphadata);
    axis image;
    axis off;    
  otherwise
end 




function analyze(src, event)
global ht linktype


switch linktype   
  case 1 % fourbar position
    a=ht.Data{1,2};
    b=ht.Data{2,2};
    c=ht.Data{3,2};
    d=ht.Data{4,2};
    AP=ht.Data{5,2};
    BAP=ht.Data{6,2}*pi/180;
    cfg=ht.Data{7,2};
    w2=ht.Data{8,2};
    simTime=ht.Data{9,2}; % seconds 
    example01_position_analysis(a,b,c,d,AP,BAP,w2,cfg,1,simTime);   
  case 2 % fourbar pva
    a=ht.Data{1,2};
    b=ht.Data{2,2};
    c=ht.Data{3,2};
    d=ht.Data{4,2};
    APlen=ht.Data{5,2};
    BAP=ht.Data{6,2}*pi/180;
    omega2=ht.Data{7,2};
    alpha2=ht.Data{8,2};
    simTime=ht.Data{9,2}; % seconds
    mrho=ht.Data{10,2};
    lw=ht.Data{11,2};
    lt=ht.Data{12,2};
    lnk_rho=mrho*lw*lt;
    F3=[ht.Data{13,2}, ht.Data{14,2}]';
    theta2=0;
    example13_pvat_analysis(a,b,c,d,APlen, BAP,theta2, omega2,alpha2, lnk_rho,...
             F2, F3, F4, rF2, rF3, rF4, T3, T4,simTime);   
  case 3 % crank slider
    a=ht.Data{1,2};
    b=ht.Data{2,2};
    c=ht.Data{3,2};
    w2=ht.Data{4,2};
    cfg=ht.Data{5,2};
    simTime=ht.Data{6,2};
    example05_crank_slider(a,b,c,w2,cfg,simTime);    
  case 4 % pantograph
    az=ht.Data{1,2};
    ab=ht.Data{2,2};
    de=ht.Data{3,2};
    yz=ht.Data{4,2};
    simTime=ht.Data{5,2};
    wAZ=ht.Data{6,2};
    aAZ=ht.Data{7,2};
    example08_pantograph(az, ab, de, yz, wAZ, aAZ, simTime);  
  case 5 % jansen
    rZA=ht.Data{1,2};
    wAZ=ht.Data{2,2};
    rAB=ht.Data{3,2};
    rBY=ht.Data{4,2};
    rZY=ht.Data{5,2};
    tYZ=ht.Data{6,2};
    rAC=ht.Data{7,2};
    rYC=ht.Data{8,2};
    rYD=ht.Data{9,2};
    rBD=ht.Data{10,2};
    rCE=ht.Data{11,2};
    rDE=ht.Data{12,2};
    rEF=ht.Data{13,2};
    rCF=ht.Data{14,2};
    FFx=ht.Data{15,2};
    FFy=ht.Data{16,2};
    lnk_rho=ht.Data{17,2};
    lnk_thickness=ht.Data{18,2};
    lnk_width=ht.Data{19,2};
    simTime=ht.Data{20,2};
    example12_jansen(rZA, wAZ, rAB, rBY, rZY, tYZ, rAC, rYC, rYD, ...
                        rBD, rCE, rDE, rEF, rCF, [FFx, FFy]', lnk_rho, ...
                        lnk_thickness, lnk_width, simTime)            
  case 6 % pantograph with hoeken
        
  otherwise
end 


