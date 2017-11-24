% NE->N

% The variable that you may play with is a, b and kexi which can control
% the staring point, the stopping point and the velocity. One thing to note
% is that the x/y coordinate sometimes may be close for distant points at
% the trajectory. It is suggested that the x coordinate of the stopping
% point should be bigger than the x coordinate of the starting point for
% the NE-> N case. For kexi, it is suggested that it should be less than 1. At least, it
% should be less than 1 at the intersection point.

function[xx,yy,k]=NE_N2()

x=[ 290         355         420         484         549         609         667 ...
    719         766         810         846         877         904         933 ...
    944         959         969         982         ...
    995         1004        1009        1027        1045 ...
    1067        1093        1126        1164        1206        1249        1297 ...
    1345        1407        1454        1506        1561        1620        1674 ...
    1731        1786        1846        1902        1962        2019        2072 ...
    2126        2178        2229        2277        2325        2374        2418 ...
    2460        2501        2538        2572        2600        2624        2644 ...
    2664        2681        2694        2702        2710        2714        2717 ...
    2716        2720        2720        2719        2725        2722        2731 ...
    2745        2769        2790        2818        2844        2877        2904 ...
    2931        2957        2979        2995        3004        3010        3013 ...
    3021        3021        3024        3024        3033        3036        3038 ...
    3043        3048        3053        3057        3062        3070        3073 ...
    3075        3082        3090        3098        3098        3107        3115 ...
    3128        3134        3137        3144        3149        3154        3160 ...
    3168        3175        3183        3191        3194        3199        3208 ...
    3218        3231        3247        3270        3296        3322        3351 ...
    3379        3424        3461        3503        3550        3599        3646];

y=[4071        4055        4037        4017        3999        3979 ...
    3957        3936        3917        3898        3881        3863 ...
    3854        3842        3836        3829        3823        ...
    3816        3815        ...
    3811        3808        3800        3793        3782 ...
    3770        3755        3739        3723        3701        3678 ...
    3657        3633        3614        3589        3566        3540 ...
    3519        3490        3466        3443        3418        3394 ...
    3370        3348        3325        3301        3281        3261 ...
    3240        3219        3201        3180        3164        3147 ...
    3132        3118        3106        3092        3081        3071 ...
    3066        3061        3056        3054        3052        3053 ...
    3054        3050        3049        3048        3046        3044 ...
    3036        3028        3018        3004        2995        2981 ...
    2971        2958        2944        2927        2906        2880 ...
    2850        2819        2782        2743        2704        2659 ...
    2611        2561        2510        2458        2404        2349 ...
    2292        2234        2175        2113        2054        1993 ...
    1933        1869        1811        1748        1684        1558 ...
    1495        1430        1366        1306        1241        1179 ...
    1116        1054         989         932         872         811 ...
    754         695         638         584         528         476 ...
    425         373         325         275         227         184 ...
    138          95          60];

a=x(5)+25; %3100;
b=x(end-1);%1500;
kexi=0.1;
D=5;

a = x(1) + round(50*rand);
b = x(end - 1) + round(50*rand);


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
