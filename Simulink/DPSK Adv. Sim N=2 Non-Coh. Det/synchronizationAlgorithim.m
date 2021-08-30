vars = {'storeIndex', 'sizeDiff', 'x' , 'y' , 'finalN', 'i', 'j', 'newX', 'indexN', 'insertMat', 'rowNume', 'rowDenom', 'row', 'szY', 'tempX', 'tempY', 'n', 'index2', 'breakterm'};
clear (vars{:});
rawx = txout.'; 
rawy = rxout.';

finalN = 3000;
magicNumber = 560070;
bitCompLen = 30000;

x = txout.';
x(x==0) = -1;
y = rxout.';
y(y==0) = -1;


% 336000

sizeDiff = size(x,2)-size(y,2);

insertMat(1:sizeDiff) = -1;

newY = [insertMat y];

index2 = 1;
for n = finalN : -1 : 1
    tempY = newY(:, n:size(newY, 2));
    tempX = x(: , 1:size(tempY, 2));
    rowNume = dot(tempX, tempY);
    rowDenom = norm(tempX) * norm(tempY);
    row(index2) = rowNume/rowDenom;
    storeIndex(index2) = n;
    index2 = index2 +1;
end


    
 [maxNum, maxIndex] = max(row);
  
plot(storeIndex, row)

xcompare = rawx(1, 2:(size(rawy,2)-(finalN-maxIndex)));
ycompare = rawy(1, (finalN-maxIndex+2):size(rawx,2));

xycompare = bitxor(xcompare(1:bitCompLen),ycompare(1:bitCompLen));
S = sum(abs(xycompare));

k = 1;
breakterm = 0;

%Check first error
% while breakterm == 0
%     runningIndex = k;
%     breakterm = xycompare(k);
%     k = k + 1;
% end


BER = S/bitCompLen
