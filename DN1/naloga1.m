
%1.1
dat = fopen('DN1\naloga1_1.txt', 'r');
name = fgetl(dat); 
formatInfo = fgetl(dat); 
numRows = 100; 
t = fscanf(dat, '%f', [1, numRows]);
fclose(dat);

%1.2
dat2 = fopen('DN1\naloga1_2.txt');
line = fgetl(fdat2);

count = 1;
while ~feof(dat2)
    line = fgetl(dat2);
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