innerRadius = 100; %mm
pitch = 7.5; %mm
angVel = 22; %mm
totalDistance = 12600; %mm
outerRadius = innerRadius + ( (pitch/ (2*pi) )* angVel ); 
%Number of turns
N = roots([pitch*.5, innerRadius, -totalDistance/(2*pi)]);
N = N(N>=0);

%thetha
th = 2 * N*pi;

%this will create values for our Archimedean Spiral plot
Th = linspace(0, th, (outerRadius)*4809.6);
x = (innerRadius + pitch.*Th/(2*pi)).*cos(Th);
y = (innerRadius + pitch.*Th/(2*pi)).*sin(Th);

%So we can allocate space for our plots
tiledlayout(2,3)

%We plot our first graph (Archimedean Spira)
nexttile;
plot(x,y)
grid("on")
title("Archimedean Spiral");
xlabel("X (milimeters)");
ylabel("Y (milimeters)");

%This is for our marker that will go around the spiral
hold on
p = plot(x(1),y(1),'o','MarkerFaceColor','red');
hold off
axis manual

%These are placeholders variables that will be needed for when we go to
%find the distance traveled
prevX = 100;
prevY = 0;

%These will hold our second plot's values  (distance over time)
timeAxis = (1:length(x));
distance = (1:length(x));

%We initial the first values for the second plot
timeAxis(1) = 0;
distance(1) = 0;

%These will hold our third plot's values (angular velocity over time)
velAxis = timeAxis;
velAxis(1) = angVel;

%Here we calculate the tangental velocities
intialTV = angVel*innerRadius;
finalTV = angVel*outerRadius;
averageTV = (intialTV + finalTV)/2;

%To find the total time it will take to travel around
timeLen = totalDistance / averageTV;

%So the number of time values match our data value
timeSegment = timeLen / length(x);

for k = 2:length(x)
    %The marker moving on the spiral
    p.XData = x(k);
    p.YData = y(k);

    %This algorithm will find the distance traveled for the second plot
    prevCoord = [prevX prevY];
    newCoord = [x(k) y(k)];
    timeAxis(k) = k * timeSegment; %assigns proper time segment
    distance(k) = distance(k-1) + norm(newCoord - prevCoord);

    %drawnow limitrate
    %updates what will be considered as the previous values
    prevX = x(k);
    prevY = y(k);
    
    %plots our angular velocity
    velAxis(k) = angVel;
end

%Plotting the second graph
nexttile([1 2])
plot(timeAxis, distance)
grid("on")
title("Distance Traveled vs Time");
xlabel("Time (seconds)");
ylabel("Distance (millimeters)");

%plotting the third graph
nexttile([1 3])
plot(timeAxis, velAxis)
grid("on")
title("Angular Velocity vs Time");
xlabel("Time (miliseconds)");
ylabel("Velocity (milirads)");

