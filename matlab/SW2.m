% SW

% The variable that you may play with is a, b and kexi which can control
% the staring point, the stopping point and the velocity. It is suggested that the x coordinate of the stopping
% point should be smaller than the x coordinate of the starting point for
% the SW case. For kexi, it is suggested that it should be less than 1. At least, it
% should be less than 1 at the intersection point.

function[xx,yy,k]=SW2()

x=[ 4490        4434        4379        4323        4264        4209        4154 ...
    4102        4046        3994        3944        3898 ...
    3850        3805        3760 ...
    3718        3675        3629        3584        3543        3499        3452 ...
    3427        3392        3360        3332        3302        3274        3253 ...
    3230        3215        3201        3195        3192        3187        3185 ...
    3182        3179        3181        3183        3179        3179        3183 ...
    3179        3178        3178        3177        3177        3176        3173 ...
    3171        3174        3171        3164        3164        3159        3167 ...
    3170        3176        3172        3172        3173        3169        3171 ...
    3174        3174        3173        3170        3170        3166        3161 ...
    3152        3139        3123        3108        3090        3062        3037 ...
    3004        2977        2944        2916        2886        2847        2811 ...
    2770        2731        2686        2647        2602        2554        2510 ...
    2471        2414        2368        2321        2273        2226        2170 ...
    2118        2068        2014        1962        1912        1856        1812 ...
    1764        1710        1657        1603        1550        1498        1439 ...
    1391        1339        1288        1230        1175        1131        1073 ...
    1024         970         918         864         804         753         697 ...
    642         585         528         470         411         351         288 ...
    56];

y=[ 2276        2304        2333        2359        2383        2408  ...
    2432        2456        2477        2501        2520        2541  ...
    2560        2578 ...
    2598        2617        2635        2651        2670        2688 ...
    2709        2728        2738        2753        2766        2777 ...
    2790        2801        2812        2823        2827        2833 ...
    2837        2836        2839        2840        2843        2842 ...
    2842        2840        2842        2843        2840        2841 ...
    2845        2844        2844        2843        2846        2846 ...
    2845        2845        2847        2849        2849        2852 ...
    2846        2846        2843        2843        2846        2844 ...
    2848        2850        2846        2848        2846        2846 ...
    2846        2847        2848        2852        2857        2866 ...
    2872        2880        2895        2906        2916        2930 ...
    2943        2956        2966        2980        3000        3011 ...
    3031        3050        3064        3085        3104        3127 ...
    3145        3172        3190        3209        3233        3252 ...
    3274        3294        3318        3342        3364        3386 ...
    3407        3428        3446        3469        3495        3516 ...
    3540        3565        3589        3608        3630        3653 ...
    3679        3700        3722        3745        3772        3795 ...
    3821        3846        3872        3896        3921        3941 ...
    3963        3978        4000        4019        4031        4044 ...
    4089];

a=x(2); %3100;
b=x(end-1); %;1500;
kexi=0.1;
D=5;

try
    
    v_x=zeros(1,length(x)-1);
    
    for i=1:1:(length(x)-1)
        
        v_x(i)=x(i+1)-x(i)+0.0001*randn; % calculate the velocity of the original data
        
    end
    
    
    
    % a=4350;
    % b=970;
    % kexi=0.1;
    % D=2; % the lane width
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
        vv(k)=v_x(floor(num1))*(1+0.1*randn);  % vv is the velocity of the car
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

