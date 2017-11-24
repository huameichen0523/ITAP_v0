% S->NE


% a: the x coordinate of the starting point;
% b: the x coordinate of the approximately stopping point;
% kexi: the velocity offset given to the car according to the velocity of
% the car from original given data, it can be varied, here it is set as 0.1;
% x: the x coordinates grabbed from original given data;
% y: the y coordinates grabbed from original given data;
% xx: the x coordinates of the generated points/car location;
% yy: the y coordinates of the generated points/car location;
% v_x: the velocity of car at the x-axis direction from orignial data;
% vv: the velocity of the car of the generated data
% D: the lane width for the car;
% k: index for the generated trajectory points;
% num1: the current car is at this point; a floating number;
% num2: the car will be at this point next frame; a floating number;
% theta:  an intermediate variable to calculate the angle in order to calculate the coordinate change because of lane change
% l: the lane car is using, 0 is middle lane, 1 is right lane, -1 is left lane;
% cl: which direction car is changing lane, 1 denotes change right, -1 denotes change left
% rn: rn is the probability that the car will change lane during one frame,
% here it is set as 0.1

% The variable that you may play with is a, b and kexi which can control
% the staring point, the stopping point and the velocity. One thing to note
% is that the x/y coordinate sometimes may be close for distant points at
% the trajectory. It is suggested that the x coordinate of the stopping
% point should be bigger than the x coordinate of the starting point for
% the S-> NE case, otherwise, the trajectory may just be south and not turn
% NE. For kexi, it is suggested that it should be less than 1. At least, it
% should be less than 1 at the intersection point. If you want to use other
% velocity pattern, you may use other formulas for kexi instead of
% kexi*randn.

function[xx,yy,k]=S_NE2()

x=[3549        3499        3453        3407        3365        3328        3294        3266        3238        3216      3197        3180        3169        3161        3155        3150        3148        3140        3133        3128        3123        3117        3114        3111        3104        3099        3095        3090        3084        3079         3076        3080        3077        3071        3067        3060        3057        3052        3048        3043        3038        3032        3031        3031        3028        3022        3020        3017        3012        3011        3008        3006        3004        3003        3000        3001        3000        2999        2998        2998        2998        2998        2998        3000        2997        2998        2998        3000        2997        2998        2997        3000        3000        2997        2999        3000        2999        2996        2998        2998        2998        2998        2997        2995        2996        2997        2998        2996        2999        2995        2998        2999        2996        3000        2997        2996        2994        2995        2997        3001        2999        2997        3000        2999        2997        3001        3000        2997        2998        2998        2995        2997        2996        2995        2991        2993        3001        3021        3044        3067        3093        3120        3155        3189        3231        3274        3320        3369        3419        3465        3515        3566        3623        3682        3745        3812        3877        3946        4019        4088        4164        4236        4314        4385        4460        4531        4606        4680        4748        4822       4894        4972];
y=[77         123         171         222         277         327         386         441         498         559         618         678         740         815         862         922         985        1047        1106        1164        1225        1282        1342        1396        1451        1510        1567        1622        1681        1737        1796        1849        1908        1960        2014        2066        2117        2165        2214        2262        2306        2351        2394        2444        2482        2526        2570        2612        2649        2679        2708        2732        2752        2769        2781        2791        2799        2805        2810        2811        2812        2815        2812        2812        2812        2812        2814        2815        2812        2813        2813        2813        2813        2813        2811        2811        2814        2813        2811        2808        2811        2809        2814        2810        2813        2810        2809        2810        2811        2811        2810        2810        2810        2809        2809        2807        2808        2810        2808        2806        2807        2807        2805        2808        2807        2808        2806        2808        2807        2807        2810        2816        2830        2842        2861        2878        2893        2908        2915        2920        2915        2911        2894        2878        2864        2843        2826        2806        2784        2763        2737        2711        2683        2657        2630        2601        2573        2548        2517        2489        2462        2435        2405        2372        2345        2312        2282        2256        2221        2190        2161        2132];

a=x(2); %3100;
b=x(end-1);%1500;
kexi=0.1;
D=5;


try
    
    
    v_x=zeros(1,length(x)-1);
    
    for i=1:1:(length(x)-1)
        
        v_x(i)=x(i+1)-x(i)+0.0001*randn; % calculate the velocity of the original data
        
    end
    
    
    
    a=3468;
    b=4820;
    kexi=0.1;
    
    D=2; % the lane width
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
        %             plot(xx(i),yy(i),'b');
        %             drawnow;
        %             %             pause(0.1);
        %         end
        plot(xx(1:k-1),yy(1:k-1),'b'); drawnow;
    end
catch ME
end

end




