vars = {'storeIndex', 'sizeDiff', 'x' , 'y' , 'finalN', 'i', 'j', 'newX', 'indexN', 'insertMat', 'rowNume', 'rowDenom', 'row', 'szY', 'tempX', 'tempY', 'n', 'index2', 'breakterm'};
clear (vars{:});
rawx = txout.'; 
rawy = rxout.';

visX= rawx(:, 1:12600*3);
visY= rawy (:, 1:12600*3);
magicNumber = 560070;
bitCompLen = 9;
initialDelayCheck = 1;
finalDelayCheck = 40000;
rxOffsetFac = 5;

x = txout.';
x(x==0) = -1;
y = rxout.';
y(y==0) = -1;

index2 = 1;
for n = initialDelayCheck : 1 : finalDelayCheck
    tempX = x(:, n:n+bitCompLen);
    tempY = y(: , rxOffsetFac:rxOffsetFac+bitCompLen);
    rowNume = dot(tempX, tempY);
    rowDenom = norm(tempX) * norm(tempY);
    row(n) = rowNume/rowDenom;
    storeIndex(n) = n;
end
    
 [maxNum, maxIndex] = max(row);
 
%  delayShift = finalN-maxIndex;
  
plot(storeIndex, row)

xcompare = rawx(1, maxIndex:maxIndex+bitCompLen);
ycompare = rawy(1, rxOffsetFac:rxOffsetFac+bitCompLen);

xycompare = bitxor(xcompare,ycompare);
S = sum(xycompare);

k = 1;
breakterm = 0;

%Check first error
% while breakterm == 0
%     runningIndex = k;
%     breakterm = xycompare(k);
%     k = k + 1;
% end


BER = S/bitCompLen
