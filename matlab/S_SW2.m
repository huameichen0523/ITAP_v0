% S->SW

% The variable that you may play with is a, b and kexi which can control
% the staring point, the stopping point and the velocity. One thing to note
% is that the x/y coordinate sometimes may be close for distant points at
% the trajectory. It is suggested that the x coordinate of the stopping
% point should be smaller than the x coordinate of the starting point for
% the S-> SW case. For kexi, it is suggested that it should be less than 1. At least, it
% should be less than 1 at the intersection point.

function[xx,yy,k]=S_SW2()

x =[3282        3251        3229        3209        3191        3178        3167        3161        3154        3150        3147        3147        3140        3131         3127        3123        3119        3112        3107        3104        3099        3090        3087        3083        3076        3068        3066        3061        3055        3049        3046        3039        3034        3028        3020        3013        3006        2998        2992        2984        2980        2973        2969        2962        2959        2955        2953        2949        2948        2946        2935        2919        2899        2867        2838        2795        2759        2715        2667        2620        2566        2520        2469        2415        2364        2310        2255        2201        2141        2086        2028        1973        1914        1856        1790        1740        1679        1610        1549        1491        1425        1360        1298        1237        1181        1114        1055         991         938         878         816         762         697         637         575         511         441         371        305         239         163          98          24];
y=[414         471      529         582         638         697        752         809         865         920         977        1034         1091        1160        1207        1261        1317        1378         1435        1492        1549        1602        1664        1721             1776        1830        1882        1933        1979        2035        2083        2133        2178        2225        2274        2319        2367        2410        2455        2504        2551        2599        2645        2691        2730        2769        2807        2842        2875        2899        2917        2937        2948        2964        2974        2992        3008        3028        3048        3069        3092        3113        3137        3161        3184        3208        3232        3255        3278        3302        3326        3350        3376        3399        3427        3449        3474        3504        3533        3558        3584        3613        3637        3664        3688        3721        3748        3777        3804        3835        3862        3889        3918        3941        3963        3986        4008        4028        4043        4059        4077        4088        4105];

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
        if (x(i)<a)
            num1=i-1+(a-x(i-1))/(x(i)-x(i-1));
            break;
        end
        
    end
    
    xx(1)=a;
    yy(1)=y(floor(num1))+((a-x(floor(num1)))/(x(floor(num1)+1)-x(floor(num1))))*(y(floor(num1)+1)-y(floor(num1)));
    
    
    while (xx(k)>b)
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
        
        xx(k+1)=xx(k+1)+D*sin(theta(k+1))*cl(k+1);
        yy(k+1)=yy(k+1)-D*cos(theta(k+1))*cl(k+1);
        
        num1=num2;
        k=k+1;
        
    end
    if isempty(find(isnan(xx))) &&  isempty(find(isnan(yy)))
        %         for i=1:1:k-1
        %             plot(xx(i),yy(i),'b');
        %             drawnow;
        %             %             pause(0.1);
        %         end
        plot(xx(1:k-1),yy(1:k-1),'b'); drawnow;
    end
catch ME
end

end
