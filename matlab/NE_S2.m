% NE->S

% The variable that you may play with is a, b and kexi which can control
% the staring point, the stopping point and the velocity. One thing to note
% is that the x/y coordinate sometimes may be close for distant points at
% the trajectory. It is suggested that the x coordinate of the stopping
% point should be bigger than the x coordinate of the starting point for
% the NE-> S case. For kexi, it is suggested that it should be less than 1. At least, it
% should be less than 1 at the intersection point.

function[xx,yy,k]=NE_S2()

x=[888         922         956         974         995        1004        1007        1010        1004        1008        1009        1007        1009        1011        1011        1011        1012        1011        1010        1013        1014        1013        1015        1013        1012        1018        1033        1050         1076        1105        1146        1188        1235        1280        1333        1386        1436        1495        1548        1604        1660        1717        1774        1838        1891        1949        2006   2066        2122        2175        2228        2281        2335        2385        2434        2479        2537        2567        2607        2646        2676        2705        2732        2763          2784        2804        2814        2822        2827        2830        2832          2834        2833        2833        2832        2836        2834        2834          2834        2836        2837        2836        2837        2835        2835          2836        2837        2838        2835        2837        2838        2836          2838        2836        2839        2839        2838        2835        2837          2839        2841        2840        2844        2841        2842        2840          2842        2840        2842        2843        2841        2843        2843          2842        2845        2845        2854        2868        2886        2900          2919        2933        2941        2949        2951        2953        2950          2944        2942        2940        2939        2933         2924        2919         2917        2910        2906        2903        2896        2889        2884        2884        2878        2875        2869        2866        2860        2856        2852        2852        2857        2864        2876        2888        2900        2923        2951        2979        3009        3053        3080        3119        3163        3203        3247];
y=[3875        3858        3844        3834        3825        3823        3822        3819        3819        3822        3819        3821       3820        3820        3821        3820        3821        3819        3820        3820        3821        3822        3822        3820        3821        3819        3813        3806        3793        3780        3763        3744        3722        3701        3679        3658         3634        3609        3587        3562        3539        3514        3487        3462        3439        3414        3390   3363        3340        3320        3297        3275        3251        3231        3212        3192        3167        3151        3134        3120        3104        3091        3080        3067        3059        3052        3048          3043        3040        3040        3039        3039        3038          3039        3038        3037        3039        3038        3038          3040        3039        3039        3038        3036        3040          3039        3037        3036        3037        3037        3037        3037        3036        3036        3036        3035        3037          3038        3037        3039        3036        3035        3033          3035        3033        3032        3034        3035        3034          3032        3033        3032        3034        3031        3033          3031        3026        3024        3023        3028        3034          3045        3060        3081        3103        3129        3162          3194        3225        3259        3292        3327         3359        3407        3458        3503        3549         3600        3650        3699        3749        3798        3846        3899        3950        3999        4051        4104        4159        4212        4263        4314        4369        4423        4474        4528        4577        4630        4683        4746        4781        4827        4878        4928        4977];

a=x(2); %3100;
b=x(end-1);%1500;
kexi=0.1;
D=5;

try
    
    
    v_x=zeros(1,length(x)-1);
    
    for i=1:1:(length(x)-1)
        
        v_x(i)=x(i+1)-x(i)+0.0001*randn; % calculate the velocity of the original data
        
    end
    
    
    
    
    k=1;
    num1=1;
    num2=1;
    xx=zeros(1,200);
    yy=zeros(1,200);
    vv=zeros(1,200);
    theta=zeros(1,200);
    l=zeros(1,200); % the lane car is using
    cl=zeros(1,200); % which direction car is changing lane
    
    for i=1:1:length(x)
        
        if (x(i)==a)
            num1=i;
            break;
        end
        if (x(i)>a)
            num1=i-1+(a-x(i-1))/(x(i)-x(i-1));
            break;
        end
        
    end
    
    xx(1)=a;
    yy(1)=y(floor(num1))+((a-x(floor(num1)))/(x(floor(num1)+1)-x(floor(num1))))*(y(floor(num1)+1)-y(floor(num1)));
    
    
    while (xx(k)<b)
        vv(k)=v_x(floor(num1))*(1+kexi*randn);  % vv is the velocity of the car
        num2=num1+(vv(k)/v_x(floor(num1)));
        
        xx(k+1)=x(floor(num2))+(num2-floor(num2))*(x(floor(num2)+1)-x(floor(num2)));
        yy(k+1)=y(floor(num2))+(num2-floor(num2))*(y(floor(num2)+1)-y(floor(num2)));
        
        % rn is a random number between (0,1), and l indicates which lane car is
        % using, cl denotes which direction car is changing lane.
        rn=rand;
        if ((l(k)==0)&&(rn<0.1))
            l(k+1)=1;
            cl(k+1)=1;
        end
        if ((l(k)==0)&&(rn>0.9))
            l(k+1)=-1;
            cl(k+1)=-1;
        end
        if ((l(k)==1)&&(rn<0.1))
            l(k+1)=0;
            cl(k+1)=-1;
        end
        if ((l(k)==-1)&&(rn>0.9))
            l(k+1)=0;
            cl(k+1)=1;
        end
        
        % change the coordinates with lane change
        
        theta(k+1)=atan((yy(k+1)-yy(k))./(xx(k+1)-xx(k)));
        
        %       theta(k+1)=atan((yy(k+1)-y(floor(num2)))./(xx(k+1)-x(floor(num2))));
        
        xx(k+1)=xx(k+1)+D*sin(theta(k+1))*cl(k+1);
        yy(k+1)=yy(k+1)-D*cos(theta(k+1))*cl(k+1);
        
        num1=num2;
        k=k+1;
        
    end
    if isempty(find(isnan(xx))) &&  isempty(find(isnan(yy)))
        %         for i=1:1:k-1
        %             plot(xx(i),yy(i),'r');
        %             drawnow;
        %             %             pause(0.1);
        %         end
        plot(xx(1:k-1),yy(1:k-1),'r'); drawnow;
    end
catch ME
end

end

