IndoorGPS
=========

Position Calculating with Trilateration via Bluetooth Beacons(Estimote).

But i have one Problem, the signal from Estimote Beacons are to low and crab!

Feel free and Program a IndoorGPS System with Wifi or what ever!

Logic
=========

You have 3 Beacons (Estimote) they have 2 Values X Coordinate and Y Coordinate (0,0) (320,0) (160,480)
The Beacons gives you Distance (2,5m etc.) 

With this Values, you can Calculating your Position.

Calculating
=========

Beacon: 
AP1( 5,5 )   
AP2( 8,5 ) 
AP3( 6.5,2.5 ) 

r1 = 2 
r2 = 2 
r3 = 2 

Solution: 
x0 = (1/delta) * (2*A*(y1-y3)-2*B*(y1-y2)) 
y0 = (1/delta) * (2*B*(x1-x2)-2*A*(x1-x3)) 

delta = 4*((x1-x2)*(y1-y3)-(x1-x3)*(y1-y2))

A = r2²-r1²-x2²+x1²-y2²+y1² 

B = r3²-r1²-x3²+x1²-y3²+y1² 

Result: 
x = 10 
y = 5 

![My image](https://github.com/N00D13/IndoorGPS/blob/master/img/trieee.gif?raw=true)

