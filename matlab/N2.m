% N

% It is suggested that the y coordinate of the stopping
% point should be less than the y coordinate of the starting point for
% the N case. For kexi, it is suggested that it should be between 0 and 1.

function[xx,yy,k]=N2()

x=[2922        2914        2906        2901        2898        2890        2888        2885        2883        2883  ...
    2883        2884        2886        2891        2895        2897        2902        2905        2909        2913 ...
    2918        2922        2926        2931        2936        2939        2942        2944        2948        2951 ...
    2953        2956        2959        2966        2968        2971        2974        2976        2981        2986 ...
    2990        2993        2998        3005        3008        3010        3012        3018        3021        3024 ...
    3031        3034        3040        3047        3053        3058        3063        3068        3073        3077 ...
    3084        3089        3097        3104        3115        3123        3130        3136        3142        3149 ...
    3155        3161        3166        3172        3177        3184        3189        3195        3200        3206 ...
    3218        3230        3247        3267        3291        3320        3356        3389        3430        3477 ...
    3520        3573        3628        3690];


y=[4438        4411        4383        4357        4332        4309        4282        4253        4225  ...
    4191        4160        4125        4092        4047        4017        3981        3944        3903 ...
    3862        3822        3782        3740        3698        3653        3613        3575        3541 ...
    3514        3486        3462        3437        3411        3385        3353        3317        3281 ...
    3242        3203        3165        3125        3083        3042        2999        2945        2906 ...
    2857        2809        2758        2709        2658        2604        2551        2494        2440 ...
    2379        2320        2256        2194        2129        2064        2002        1937        1871 ...
    1807        1744        1679        1616        1550        1488        1424        1361        1299 ...
    1238        1174        1114        1054         992         927         864         802         743 ...
    679         617         558         497         441         382         328         274         218  ...
    171         119          75          29];

a=y(2); %3100;
b=y(end-1); %;1500;
kexi=0.2;
D=5;
numTracks_N = 600;


try
    
    v_x=zeros(1,length(x)-1);
    
    for i=1:1:(length(x)-1)
        
        v_x(i)=x(i+1)-x(i)+0.0001*randn; % calculate the velocity of the original data
        
    end
    
    
    
    % a=4370;  % use the y coordinate for starting point
    % b=100;   % use the y coordinate for stopping point
    % kexi=0.2;
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
        
        if (y(i)==a)
            num1=i;
            break;
        end
        if (y(i)<a)
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




