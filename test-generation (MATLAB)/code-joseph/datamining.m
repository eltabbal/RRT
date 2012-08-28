function [ cluster clusterSize ] = datamining( config )
sample = zeros(config.learningSamples,2);
count=1;
hold on

for i=1:config.learningSamples,
    x = (config.xmax-config.xmin)*rand + config.xmin;
    y = (config.ymax-config.ymin)*rand + config.ymin ;
    t = config.sim_time+3*rand ;
    [ts,ys] = ode45(@josephson,[0,t],[x;y], [], [0;0]); 
    plot(ys(:,1),ys(:,2)); 
    sample(count, 1)=ys(size(ys,1),1);
    sample(count, 2)=ys(size(ys,1),2);
    count=count+1;
end


%for i=config.resolution*config.xmin:config.resolution*config.xmax,
%    for j=config.resolution*config.ymin:config.resolution*config.ymax,
%        [ts,ys] = ode45(config.system,[0,config.sim_time+3*rand],[i*(1/config.resolution);j*(1/config.resolution)]); 
%        plot(ys(:,1),ys(:,2)); 
%        sample(count, 1)=ys(size(ys,1),1);
%        sample(count, 2)=ys(size(ys,1),2);
%        count=count+1;
%    end
%end
%vectfield(config.system,config.xmin:.05:config.xmax,config.ymin:.05:config.ymax); 
figure(2)
scatter(sample(:,1), sample(:,2))
hold off

%Z=zeros(20,20);
Z=zeros(20,20);
for i=1:size(sample,1),
    x=sample(i,1);
    y=sample(i,2); 
    %Z(4+floor(x*10), 4+floor(y*10)) = Z(4+floor(x*10), 4+floor(y*10))+1;
    if(y>=4) y=0;
    end
    if(x>=4) x=0;
    end
    
    if(y<=-4), 
        y=0;
    end
    if(x<=-4),
        x=0;
    end
    Z(10+floor(x), 10+floor(y)) = Z(10+floor(x), 10+floor(y))+1;
end

for i=1:20,
    for j=1:20,
        Y(i,j)=Z(i,j);
    end
end


%upward-smoothing
for i=1+1:20-1,
    for j=1+1:20-1,
        x = Y(i,j);
        if(Z(i-1,j-1)<x), 
            Z(i-1,j-1)= ( x + Z(i-1,j-1) )/2;
        end
        
        if(Z(i,j-1)<x), 
            Z(i,j-1)= ( x + Z(i,j-1) )/2;
        end
        
        if(Z(i+1,j-1)<x), 
            Z(i+1,j-1)= ( x + Z(i+1,j-1) )/2;
        end
        
        if(Z(i-1,j)<x), 
            Z(i-1,j)= ( x + Z(i-1,j) )/2;
        end
        
        if(Z(i+1,j)<x), 
            Z(i+1,j)= ( x + Z(i+1,j) )/2;
        end
        
        if(Z(i-1,j+1)<x), 
            Z(i-1,j+1)= ( x + Z(i-1,j+1) )/2;
        end
        
        if(Z(i,j+1)<x), 
            Z(i,j+1)= ( x + Z(i,j+1) )/2;
        end
        
        if(Z(i+1,j+1)<x), 
            Z(i+1,j+1)= ( x + Z(i+1,j+1) )/2;
        end
    end
end

min=1; max=1;

for i=1:20
    for j=1:20
        if Z(i,j)<min, 
            min=Z(i,j);
        end
        if Z(i,j)>max, 
            max=Z(i,j);
        end        
    end
end

%for i=1:20
%    for j=1:20
%        if Z(i,j)<min, 
%            min=Z(i,j);
%        end
%        if Z(i,j)>max, 
%            max=Z(i,j);
%        end
%        
%    end
%end

%grid-based clustering
p = (max-min)/config.numberOfClusters;
clusterSize = zeros(config.numberOfClusters,1);
cluster = zeros(config.numberOfClusters, 20*20);
for i=1:20
    for j=1:20
        c = ceil(Z(i,j)/p);
        if (c==0) 
            c=1;
        end
        cluster ( c, clusterSize(c)+1 ) = 20*i+j;
        clusterSize(c)=clusterSize(c)+1;
    end
end

for i=1:20,
    for j=1:20,
        Y(i,j)=(-Z(j,i))+1;
    end
end



figure(3)
surf(Y);

end

