% N->NE

% The variable that you may play with is a, b and kexi which can control
% the staring point, the stopping point and the velocity. One thing to note
% is that the x/y coordinate sometimes may be close for distant points at
% the trajectory. It is suggested that the x coordinate of the stopping
% point should be bigger than the x coordinate of the starting point for
% the N-> NE case. For kexi, it is suggested that it should be less than 1. At least, it
% should be less than 1 at the intersection point.

function[xx,yy,k]=N_NE2()

x=[ 3301        3259        3221        3183        3145        3110        3074 ...
    3047        3015        2990        2968        2945        2933        2921 ...
    2912        2908        2903        2902        2903        2909        2912 ...
    2916        2921        2925        2930        2930        2934        2937 ...
    2941        2942        2947        2949        2952        2958        2961 ...
    2963        2965        2968        2971        2973        2976        2980 ...
    2979        2983        2983        2984        2983        2986        2990 ...
    2993        2996        2999        3002        3006        3010        3015 ...
    3018        3033        3053        3083        3119        3157        3200 ...
    3237        3283        3317        3355        3391        3433        3471 ...
    3508        3550        3589        3622        3661        3695        3727 ...
    3763        3803        3844        3893        3939        3990        4047 ...
    4104        4162        4225        4290        4355        4418        4481 ...
    4543        4607        4673        4739        4804        4869        4940];

y=[4962        4915        4866        4823        4777        4734 ...
    4686        4639        4596        4549        4498        4454 ...
    4403        4345        4307        4258        4210        4160 ...
    4112        4066        4023        3936        3905        3875 ...
    3842        3811        3779 ...
    3748        3716        3688        3657        3625        3596 ...
    3563        3525        3502        3471        3440        3416 ...
    3395        3375        3357        3341        3326        3312 ...
    3293        3277        3258        3234        3209        3179 ...
    3152        3122        3090        3056        3026        3001 ...
    2974        2954        2934        2919        2903        2884 ...
    2866        2848        2831        2815        2799        2779 ...
    2765        2748        2728        2713        2699        2683 ...
    2667        2655        2638        2623        2604        2584 ...
    2562        2541        2517        2492        2468        2443 ...
    2415        2387        2361        2336        2305        2278 ...
    2251        2221        2196        2171        2143];

a=x(2); % x coordinate of starting point
b=x(end-1);  % x coordinate of stopping point
kexi=0.1;
D=5; % the lane width

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
        %             plot(xx(i),yy(i),'g');
        %             drawnow;
        %             %             pause(0.1);
        %         end
        plot(xx(1:k-1),yy(1:k-1),'g'); drawnow;
    end
catch ME
end

end