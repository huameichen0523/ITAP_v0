% N->SW

% The variable that you may play with is a, b and kexi which can control
% the staring point, the stopping point and the velocity. One thing to note
% is that the x/y coordinate sometimes may be close for distant points at
% the trajectory. It is suggested that the x coordinate of the stopping
% point should be smaller than the x coordinate of the starting point for
% the N-> SW case. For kexi, it is suggested that it should be less than 1. At least, it
% should be less than 1 at the intersection point.

function[xx,yy,k]=N_SW2()

x=[ 3301        3259        3221        3183        3145        3110        3074 ...
    3047        3015        2990        2968        2945        2933        2921 ...
    2912        2908        2903        2902        2903        2909        2912 ...
    2917        2919        2923        2923        2928        2930        2927 ...
    2932        2933        2935        2937        2940        2945        2948 ...
    2949        2952        2957        2959        2962        2966        2967 ...
    2967        2967        2965        2964        2966        2970        2972 ...
    2974        2977        2976        2979        2979        2982        2980 ...
    2981        2981        2981        2979        2980        2979        2980 ...
    2982        2979        2979        2980        2981        2980        2980 ...
    2980        2980        2980        2980        2981        2980        2983 ...
    2980        2982        2981        2981        2980        2978        2979 ...
    2979        2979        2979        2979        2977        2980        2978 ...
    2975        2979        2980        2977        2977        2978        2981 ...
    2980        2978        2979        2978        2976        2977        2978 ...
    2975        2975        2976        2976        2977        2976        2978 ...
    2979        2979        2981        2975        2967        2953        2935 ...
    2914        2886        2860        2833        2803        2773        2738 ...
    2700        2663        2622        2584        2544        2505        2462 ...
    2422        2375        2329        2285        2238        2193        2144 ...
    2095        2045        2003        1954        1906        1862        1816 ...
    1770        1725        1683        1643        1592        1552        1508 ...
    1461        1418        1375        1330        1286        1238        1187 ...
    1140        1095        1046         991         938         878         816 ...
    762         697         637         575         511         441         371 ...
    305         239         163          98          24];

y=[4962        4915        4866        4823        4777        4734 ...
    4686        4639        4596        4549        4498        4454 ...
    4403        4345        4307        4258        4210        4160 ...
    4112        4066        4023        3977        3939        3902 ...
    3864        3827        3793        3761        3725        3692 ...
    3660        3626        3594        3561        3528        3496 ...
    3466        3436        3402        3373        3344        3310 ...
    3281        3249        3228        3200        3177        3152 ...
    3133        3109        3091        3079        3068        3061 ...
    3056        3053        3048        3050        3049        3052 ...
    3049        3047        3047        3048        3046        3049 ...
    3049        3047        3049        3047        3046        3048 ...
    3049        3047        3049        3048        3046        3047 ...
    3045        3042        3045        3043        3046        3043 ...
    3045        3043        3043        3045        3044        3044 ...
    3046        3045        3042        3040        3041        3042 ...
    3040        3040        3042        3041        3040        3044 ...
    3042        3041        3042        3041        3039        3040 ...
    3040        3040        3037        3034        3025        3012 ...
    3000        2985        2974        2964        2955        2952 ...
    2955        2962        2970        2981        2995        3009 ...
    3023        3041        3058        3076        3092        3111 ...
    3129        3153        3167        3189        3208        3227 ...
    3252        3273        3293        3317        3332        3356 ...
    3375        3395        3416        3437        3456        3473 ...
    3492        3517        3532        3551        3572        3589 ...
    3609        3625        3646        3667        3685        3707 ...
    3729        3747        3777        3804        3835        3862 ...
    3889        3918        3941        3963        3986        4008 ...
    4028        4043        4059        4077        4088        4105];

a=x(2); %3100;
b=x(end-1);%1500;
kexi=0.1;
D=5;


try
    % the lane widthv_x=zeros(1,length(x)-1);
    
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
        %             plot(xx(i),yy(i),'g');
        %             drawnow;
        %             %             pause(0.1);
        %         end
        %     else
        %         'here'
        plot(xx(1:k-1),yy(1:k-1),'g'); drawnow;
    end
catch ME
end
%figure(1);
%imshow('100.jpg');
%hold on;
%plot(x,y,'r*',xx(1:k-1),yy(1:k-1),'bo');
end

