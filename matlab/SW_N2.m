% SW->N

% In this script, the y coordinates of starting and stopping point are
% used.

% The variable that you may play with is a, b and kexi which can control
% the staring point, the stopping point and the velocity. One thing to note
% is that the x/y coordinate sometimes may be close for distant points at
% the trajectory. It is suggested that the y coordinate of the stopping
% point should be smaller than the y coordinate of the starting point for
% the SW-> N case. For kexi, it is suggested that it should be greater
% than 0, and less than 1.

function[xx,yy,k]=SW_N2()

x=[  4490        4434        4379        4323        4264        4209        4154 ...
    4102        4046        3994        3944        3898     3850        3805        3760 ...
    3718        3675   3629 ...
    3576        3529        3484        3445        3405        3357 ...
    3329        3291        3261        3230        3207        3190        3175 ...
    3165        3158        3151        3149        3149        3148        3148 ...
    3149        3148        3149        3150        3150        3150        3151 ...
    3152        3150        3149        3149        3150        3151        3151 ...
    3149        3149        3149        3147        3148        3149        3149 ...
    3147        3144        3146        3146        3145        3143        3136 ...
    3129        3119        3105        3088        3059        3049        3041 ...
    3040        3039        3039        3039        3041        3045        3048 ...
    3052        3057        3059        3065        3070        3075        3079 ...
    3085        3090        3095        3100        3108        3112        3119 ...
    3125        3133        3136        3144        3149        3154        3156 ...
    3163        3169        3179        3186        3192        3200        3212 ...
    3221        3236        3253        3275        3305        3339        3377 ...
    3421        3470        3524        3581        3640        3705];

y=[ 2276        2304        2333        2359        2383        2408  ...
    2432        2456        2477        2501        2520        2541  ...
    2560        2578        2598        2617        2635        2651  ...
    2660        2681        2696        2716 ...
    2733        2752        2766        2782        2794        2806 ...
    2817        2824        2832        2835        2836        2838 ...
    2840        2840        2841        2840        2842        2840 ...
    2841        2840        2840        2841        2840        2839 ...
    2841        2840        2841        2840        2840        2840 ...
    2840        2841        2840        2841        2839        2840 ...
    2840        2840        2840        2840        2842        2842 ...
    2842        2846        2848        2851        2854        2853 ...
    2838        2823        2804        2782        2755        2724 ...
    2692        2656        2614        2569        2521        2472 ...
    2419        2366        2311        2249        2190        2130 ...
    2070        2005        1942        1878        1816        1749 ...
    1685        1622        1552        1487        1420        1351 ...
    1278        1213        1142        1073        1006         935 ...
    868         798         728         662         596          529 ...
    465         404         341         283         225         167 ...
    115          67          20];

a=y(2); %3100;
b=y(end-1);%1500;
kexi=0.1;
D=5;

try
    
    v_x=zeros(1,length(x)-1);
    
    for i=1:1:(length(x)-1)
        
        v_x(i)=x(i+1)-x(i)+0.0001*randn; % calculate the velocity of the original data
        
    end
    
    
    
    % a=2333;
    % b=115;
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
    
    
    while (yy(k)>b)
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

