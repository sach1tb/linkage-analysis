function linkage_analysis(linkage, varargin)

%
% wip, not tested yet, and may not provide all functionality.
%
% --SB, NIU, 2018

% default script runs the Hoeken's linkage
if nargin < 1, linkage='fourbar'; end

p = inputParser;
addRequired(p,'linkage');
addOptional(p,'omegaInput',1);
addOptional(p,'alphaInput',0);
addOptional(p,'linkLengths',[10 25 25 20]);
addOptional(p,'theta2',0);
addOptional(p,'simTime',10);
addOptional(p,'couplerAngle',0);
addOptional(p,'couplerLength',50);
addOptional(p,'groundOrientation',0);

parse(p,linkage, varargin{:});

linkLengths = p.Results.linkLengths;
omegaInput  = p.Results.omegaInput;
alphaInput  = p.Results.alphaInput;
theta2      = p.Results.theta2;
simTime     = p.Results.simTime;
couplerAngle     = p.Results.couplerAngle;
couplerLength     = p.Results.couplerLength;
groundOrientation = p.Results.groundOrientation;

switch linkage
    case 'fourbar'
        a=linkLengths(1);
        b=linkLengths(2);
        c=linkLengths(3);
        d=linkLengths(4);
        figure(1); gcf; clf;

        
        if omegaInput==0
            [t3o, t3c, t4o, t4c]=fourbar_position(a, b, c, d, theta2);
            fprintf('t3(o) \t\t t3(c) \t\t t4(o) \t\t t4(c)\n');
            fprintf('%.2f \t\t %.2f \t\t %.2f \t\t %.2f radians \n', t3o, t3c, t4o, t4c);
            fprintf('%.2f \t\t %.2f \t\t %.2f \t\t %.2f degrees \n', t3o*180/pi, t3c*180/pi, t4o*180/pi, t4c*180/pi);
            subplot(2,3,1);
            fourbar_plot(a,b,c,d,couplerAngle,couplerLength, t2,t3o,t4o,groundOrientation)
        else
            t=0:0.05:simTime;
%             theta2=omegaInput*t;
%             [t3o, t3c, t4o, t4c]=fourbar_position(a, b, c, d, theta2);

            [a3, a4, w3, w4, t3o, t4o, t3c, t4c, theta2]=fourbar_acceleration(a,b,c,d,alphaInput,omegaInput, t);



            subplot(2,3,1);
            for ii=1:3:12 %round(numel(t)/3):numel(t)
%                 clrs=eye(3) + (ones(3)-eye(3))*ii/numel(t);
                clrs=eye(3) + (ones(3)-eye(3))*ii/12;
                fourbar_plot(a,b,c,d,couplerAngle,couplerLength, theta2(ii),t3o(ii),t4o(ii),groundOrientation, clrs);
                hold on;
            end
            
            % update angles ground orientation
            theta2=theta2+groundOrientation;
            t3o=t3o+groundOrientation;
            t4o=t4o+groundOrientation;
            t3c=t3c+groundOrientation;
            t4c=t4c+groundOrientation;
            
            
            % trace
            r3x=a*cos(theta2)+b*cos(t3o);
            r3y=a*sin(theta2)+b*sin(t3o);
            plot(r3x,r3y, 'b.', 'linewidth', 2);
            
            
            rcx=a*cos(theta2)+couplerLength*cos(t3o+couplerAngle);
            rcy=a*sin(theta2)+couplerLength*sin(t3o+couplerAngle);
            plot(rcx,rcy, 'k.', 'linewidth', 2);
            
            subplot(2,3,2);
            plot(t, atan(tan(theta2)), 'linewidth', 1);
            hold on; % holds the plot for another graph
            plot(t, t3o, 'g', 'linewidth', 2); % plot theta_3 against time

            plot(t, t4o, 'b', 'linewidth', 2); % plot theta_4 against time
            plot(t, abs(acos(cos(t3o-t4o))), 'linewidth', 2);
            plot(t, 40*pi/180*ones(1, numel(t)), 'k--');
            
            grid on;
            xlabel('time (s)');
            ylabel('\theta (radians)');
            legend('\theta_2', '\theta_3', '\theta_4', '\mu', '40^{\circ}')
            set(gca, 'fontsize', 24, 'fontname', 'times'); 
            
            
            subplot(2,3,3);
            plot(t, r3x, 'g', 'linewidth', 2);
            hold on; % holds the plot for another graph
            plot(t, r3y, 'g-.', 'linewidth', 2); 
            
            grid on;
            xlabel('time (s)');
            ylabel('position');
            legend('R_3(x)', 'R_3(y)')
            set(gca, 'fontsize', 24, 'fontname', 'times'); 
            
            
            subplot(2,3,4);
            plot(t, rcx, 'k', 'linewidth', 2);
            hold on; % holds the plot for another graph
            plot(t, rcy, 'k--', 'linewidth', 2); 
            
            grid on;
            xlabel('time (s)');
            ylabel('position');
            legend('R_c(x)', 'R_c(y)')
            set(gca, 'fontsize', 24, 'fontname', 'times'); 
            
            subplot(2,3,5);
%             [w3, w4]=fourbar_velocity(a, b, c, d, omegaInput, t);
            
            plot(t, w3, 'g', 'linewidth', 2); 
            hold on;
            plot(t, w4, 'b', 'linewidth', 2);
            grid on;
            xlabel('time (s)');
            ylabel('angular velocity (rad/s)');
            legend('\omega_3', '\omega_4')
            set(gca, 'fontsize', 24, 'fontname', 'times'); 
            
            
            subplot(2,3,6);
%             [a3, a4]=fourbar_acceleration(a, b, c, d, alphaInput, omegaInput, t);
            
            plot(t, a3, 'g', 'linewidth', 2); 
            hold on;
            plot(t, a4, 'b', 'linewidth', 2);
            grid on;
            xlabel('time (s)');
            ylabel('angular acceleration (rad/s^2)');
            legend('\alpha_3', '\alpha_4')
            set(gca, 'fontsize', 24, 'fontname', 'times');
            
        end
    otherwise
end



