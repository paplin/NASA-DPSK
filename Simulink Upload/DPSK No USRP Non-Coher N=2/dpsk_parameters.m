close all; clear all; clc;

M = 2;
phaseoffset = 0; %Do not change phase offset
snr = 20;
samples = 1;
stopTime = 5E5;
stepSize = 1;

img = sqrt(-1);

for i = 1:M
    phaseConstel(i) = cos(2*pi*(i-1)/M +phaseoffset) + img*sin(2*pi*(i-1)/M +phaseoffset);
end

angleConstel = angle(phaseConstel);

for j = 1:size(angleConstel,2)
    if angleConstel(j) < 0
        angleConstel(j) = angleConstel(j) + (2*pi);
    end
end


%%%% Advanced AWGN Parameters %%%%%


