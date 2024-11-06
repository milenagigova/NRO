
%1.1
fileID = fopen('DN1\naloga1_1.txt', 'r');
name = fgetl(fileID); 
formatInfo = fgetl(fileID); 
numRows = 100; 
t = fscanf(fileID, '%f', [1, numRows]);
fclose(fileID);

%1.2
fid = fopen('DN1\naloga1_2.txt');
line = fgetl(fid);

count = 1;
while ~feof(fid)
    line = fgetl(fid);
    P(count) = str2double(line);

    count = count+1;
end
P = P.';

figure(1);

plot(t, P);
title("graf P(t)");
xlabel("t[s]");
ylabel("P[W]");

%1.3
sum = 0;
for index = 1:size(P, 1)
    if index == 1 || index == size(P, 1)
        sum = sum + P(index);
    else
        sum = sum + 2*P(index);
    end
end
step = t(2) - t(1);

integRes = (step/2)*sum
integResTrapz = trapz(t, P)