% NE

% It is suggested that the x coordinate of the stopping
% point should be bigger than the x coordinate of the starting point for
% the NE case. For kexi, it is suggested that it should be between 0 and 1.

function[xx,yy,k]=NE2()

x=[290         355         420         484         549         609         667         719         766         810         846         877         904         933         944         959         974         995        1004        1007      1010        1004        1008        1009        1007        1009        1011        1011        1011        1012        1011        1010        1013        1014         1013        1015        1013        1012        1018        1033        1050        1076        1105        1146        1188        1235        1280        1333        1386        1436        1495        1548        1604        1660        1717        1774        1838        1891        1949        2006        2069        2129        2187        2245        2299        2349        2398        2447        2493        2534        2576        2615        2649        2679        2706        2729        2748        2762        2770        2772        2778        2777        2780        2781        2781        2781        2781        2784        2786        2793        2802        2816        2833        2851        2869        2887        2917        2940        2965        2995        3025        3057        3092        3128        3166        3212        3257        3298        3342        3387        3429        3473        3518        3556        3599        3635        3669        3731        3799        3870        3934        4005        4075        4150        4223        4294        4366        4435        4507        4576        4649        4713        4783        4849        4916        4984];

y=[4071        4055        4037        4017        3999        3979        3957        3936        3917        3898        3881        3863        3854        3842        3836        3829        3834        3825        3823      3822        3819        3819        3822        3819        3821      3820        3820        3821        3820        3821        3819        3820        3820        3821        3822        3822        3820         3821        3819        3813        3806        3793        3780        3763        3744        3722        3701        3679        3658        3634        3609        3587        3562        3539        3514        3487        3462        3439        3414        3390        3364        3343        3318        3288        3269        3247        3227        3205        3185        3167        3149        3133        3116        3103        3093        3081        3074        3068        3064        3063        3060        3059        3061        3059        3060        3060        3059        3057        3056        3054        3048        3042        3036        3028        3020        3012        3000        2988        2977        2966        2952        2940        2922        2909        2892        2872        2855        2835        2817        2798        2778        2760        2739        2723        2705        2687        2664        2637        2612        2579     2551        2523        2493        2461        2428        2401        2373        2344        2316     2287        2257        2232        2202        2177        2154        2127];


a=x(2); %3100;
b=x(end-1); %;1500;
kexi=0.2;
D=5;

try
    
    v_x=zeros(1,length(x)-1);
    
    for i=1:1:(length(x)-1)
        
        v_x(i)=x(i+1)-x(i)+0.0001*randn; % calculate the velocity of the original data
        
    end
    
    
    
    %a=403;   % 403
    %b=4873;  % 4873
    %kexi=0.2;
    %D=2; % the lane width
    k=1;
    num1=1;
    num2=1;
    xx=zeros(1,200);
    yy=zeros(1,200);
    xx2=zeros(1,200);
    yy2=zeros(1,200);
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
        %             plot(xx(i),yy(i),'b');
        %             drawnow;
        %             %             pause(0.1);
        %         end
        plot(xx(1:k-1),yy(1:k-1),'b'); drawnow;
    end
catch ME
end

end



