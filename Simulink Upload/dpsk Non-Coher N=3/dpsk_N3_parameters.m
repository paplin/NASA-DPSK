close all; clear all; clc;

M = 4;
N = 3;
phaseoffset = 0;
snr = 15;
samples = 1;
stopTime = 1E5;
stepSize = 1;

img = sqrt(-1);

for i = 1:M+1
    bothDelTheta(i) = cos(2*pi*(i-1)/M +phaseoffset) + img*sin(2*pi*(i-1)/M +phaseoffset);
end

angleConstel = angle(bothDelTheta);

for j = 1:size(angleConstel,2)
    if angleConstel(j) < 0
        angleConstel(j) = angleConstel(j) + (2*pi);
    end
end

for q = 1:size(angleConstel, 2)
    for r = 1:M+1
            mainMat(1,r,q) = angleConstel(r);
            mainMat(2,r,q) = angleConstel(q) - mainMat(1,r,q);
            bothMat(1,r,q) = angleConstel(q);
            bothMat(2,r,q) = angleConstel(q);
    end
end

for in1 = 1:size(mainMat,1)
    for in2 = 1:size(mainMat, 2)
        for in3 = 1:size(mainMat, 3)
                 if mainMat(in1,in2,in3) < 0
        mainMat(in1,in2,in3) = mainMat(in1,in2,in3) + (2*pi);
                 end  
        end
    end
end

