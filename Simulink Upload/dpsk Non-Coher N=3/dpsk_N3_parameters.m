close all; clear all; clc;

M = 4;
N = 3;
phaseoffset = 0;
snr = 300;
samples = 1;
stopTime = 1E4;
stepSize = 1;

indexCheck = pi/2;

img = sqrt(-1);

for i = 1:M
    bothDelTheta(i) = cos(2*pi*(i-1)/M +phaseoffset) + img*sin(2*pi*(i-1)/M +phaseoffset);
end

angleConstel = mod(angle(bothDelTheta), 2*pi);


for q = 1:size(angleConstel, 2)
    for r = 1:M
            mainMat(1,r,q) = angleConstel(r);
            mainMat(2,r,q) = angleConstel(q) - mainMat(1,r,q);
            mainMat(3,r,q) = angleConstel(q);
            preIndexMat(1,r,q) = mainMat(1,r,q)/(pi/2);
            preIndexMat(2,r,q) = mod(mainMat(2,r,q),2*pi)*2/pi;
    end
end

indexMat = reshape(preIndexMat, 2, M^2);

for in1 = 1:size(mainMat,1)
    for in2 = 1:size(mainMat, 2)
        for in3 = 1:size(mainMat, 3)
                 if mainMat(in1,in2,in3) < 0
        mainMat(in1,in2,in3) = mainMat(in1,in2,in3) + (2*pi);
                 end  
        end
    end
end

