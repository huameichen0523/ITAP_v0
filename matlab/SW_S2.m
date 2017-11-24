% SW->S

% It is suggested that the y coordinate of the stopping
% point should be bigger than the y coordinate of the starting point for
% the SW->S case. For kexi, it is suggested that it should be between 0.1 and 0.5.

function[xx,yy,k]=SW_S2()

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
    3004        2977        2970        2965        2963        2959        2954        2951 ...
    2944        2942        2938        2935        2927        2924        2919 ...
    2917        2910        2906        2903        2896        2889        2884 ...
    2884        2878        2875        2869        2866        2860        2856 ...
    2852        2852        2857        2864        2876        2888        2900 ...
    2923        2951        2979        3009        3053        3080        3119 ...
    3163        3203        3247];

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
    2943        2970        2999        3031 ...
    3067        3106        3144        3185        3226        3272 ...
    3317        3359        3407        3458        3503        3549 ...
    3600        3650        3699        3749        3798        3846 ...
    3899        3950        3999        4051        4104        4159 ...
    4212        4263        4314        4369        4423        4474 ...
    4528        4577        4630        4683        4746        4781 ...
    4827        4878        4928        4977];


a=y(2); %3100;
b=y(end-1);%1500;
kexi=0.1;
D=5;

try
    
    
    v_x=zeros(1,length(x)-1);
    
    for i=1:1:(length(x)-1)
        
        v_x(i)=x(i+1)-x(i)+0.0001*randn; % calculate the velocity of the original data
        
    end
    
    
    
    % a=2304;
    % b=4928;
    % kexi=0.3;
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
    
    for i=1:1:length(y)
        
        if (y(i)==a)
            num1=i;
            break;
        end
        if (y(i)>a)
            num1=i-1+(a-y(i-1))/(y(i)-y(i-1));
            break;
        end
        
    end
    
    yy(1)=a;
    xx(1)=x(floor(num1))+((a-y(floor(num1)))/(y(floor(num1)+1)-y(floor(num1))))*(x(floor(num1)+1)-x(floor(num1)));
    
    while (yy(k)<b)
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
%             plot(xx(i),yy(i),'y');
%             drawnow;
%             %             pause(0.1);
%         end
        plot(xx(1:k-1),yy(1:k-1),'y'); drawnow;
    end
catch ME
end

end
