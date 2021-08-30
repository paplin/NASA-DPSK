%{
Multi-Symbol(N) Non-Coherent Detection Code for DBPSK Transmitter
By Peyton Aplin
Montana State University
%}

close all; clear all; clc;
%% Input the Constellation and the multi-symbol detection factor here %%
A = [0 pi];
M = size(A, 2);
N = 2
%% Save incoming data bits as rxBitsRaw
while N < 6
load('dpsk_Optsim2')
dataTxMat = El3;
dataTxMat(dataTxMat == 0) = 2;
dataTxMat(dataTxMat == 1) = 0;
dataTxMat(dataTxMat == 2) = 1;

txDataMat = [dataTxMat];
delay = 23;
numSamps = 52;
j = 1;
for i = delay: numSamps: size(txDataMat, 1) - 25
 txDiffyBits(j, :) = El3(i, :);
j = j +1;
end

txDataBits(1, :) = txDiffyBits(1,:);
for c = 2:size(txDiffyBits,1)
     txDataBits(c, :) = abs(txDiffyBits(c, :) - txDiffyBits(c-1, :));
end


rxData = Opt2(:, 1);

m = 1;
for k = delay: numSamps : size(rxData, 1) - 25

rxBitsRaw(m, :) = rxData(k, :);
m = m + 1;
end

%% Changing data from complex to angle form

twoPi = 2*pi;
rxAngle = angle(rxBitsRaw);
checkBefore = rxAngle;
rxAngleMod1 = mod(rxAngle, (twoPi));

%%  Creating multiple arrays for the neccesary delays
% makeM(A, N);

nAlg = N-1;
s = repmat({A},1,nAlg);
[ans{nAlg:-1:1}] = ndgrid(s{:});
ans = reshape(cat(nAlg,ans{:}),[],nAlg);

 for i = 1:N-1
  eval(['delay_' num2str(i) ' = dsp.Delay(i);']);
 end

%% Creating the correct decesion contributor terms and storing them as seperate arrays

for p = 1: N - 1
     if p == 1
       eval(['decContri_T' num2str(p) ' = ans;']);
     else
         for q = 1:N - p
             for j = 1:size(ans,1)
         holdVar(j, q) = mod(sum(ans(j, q:q+p-1)), 2*pi) ;
            end
         eval(['decContri_T' num2str(p) ' = holdVar;']);
        end
     end
          clear holdVar
end

%% Creating delayBits matrix with all the necessary delays

for w = 1:N-1
    holdVar2 = eval(['delay_' num2str(w)]);
    delayBits(:, w) =  holdVar2(rxAngleMod1);
end
delayBits = [rxAngleMod1 delayBits];
%% Subtracting the original bit data from each delayBits collumn. Using the Modulo function to polish data.
for p = 1: N - 1
         for q = 1:N - p
             for j = 1:size(delayBits,1)
         holdVar3(j, q) = abs(delayBits(j,q) - delayBits(j, q+p));
            end
         eval(['firstSubtract_T' num2str(p) ' = holdVar3;']);
         end
         clear holdVar3
end         

%% Subtracting the decesion contributor arrays from the incoming data for each combination
for p = 1:size(delayBits, 1)
    for q = 1:size(decContri_T1, 1)
            for r = 1:N-1
            holdVar4 = eval(['firstSubtract_T' num2str(r)]);
            holdVar5 = eval(['decContri_T' num2str(r)]);
%             secondSubtractTest(p,q,r) = abs(holdVar4(p, :) - holdVar5(q, :));
            secondSubtract(p,q,r) = sum(mod(abs(holdVar4(p, :) - holdVar5(q, :)), 3*pi/2));
            end
    end
end


sumSecSub = sum(secondSubtract, 3);

%% Finding the max index and max value for each row
[minValue, minIndex] = min(sumSecSub, [], 2);

%% Indexing decContri_T1 array which contains the most likely combination of bits

   runInd = 1;
for k = N:N-1:size(minIndex,1)
    storeFinalModAng(runInd, :) = decContri_T1(minIndex(k), :);
    runInd = runInd + 1;
end

    runInd2 = 1;
    rxDataBits(1, :) = [0];
for r =N:N-1:size(minIndex,1)
        for s = 1:size(storeFinalModAng,2)
    if storeFinalModAng(runInd2, s) == 0
        rxDataBits(r-(s-1), :) = [0];
    elseif storeFinalModAng(runInd2, s) == pi
        rxDataBits(r-(s-1), :) = [1];
    end
        end
        runInd2 = runInd2 + 1;
end
%% BER Calculation
xorMat = bitxor(txDataBits(1:size(rxDataBits), :), rxDataBits);
preSum = sum(xorMat);
S = sum(preSum);

BER(N) = S/(size(rxDataBits, 1) * 2)
if N == 3
    N = 5
else
    N = N + 1;
end

close all; 
clearvars -except out BER N A M optsimData
clc;
end