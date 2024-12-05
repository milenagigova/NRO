clc;
clear all;


vozlisca = readmatrix('vozlisca_temperature_dn2.txt', 'NumHeaderLines', 4);
x = vozlisca(:, 1);
y = vozlisca(:, 2);
T = vozlisca(:, 3);

celice = readmatrix('celice_dn2.txt', 'NumHeaderLines', 2);


x_target = 0.403;
y_target = 0.503;


time_elapsed = zeros(1, 3);

%% 1. Metoda: scatteredInterpolant
tic;
scattered_interp = scatteredInterpolant(x, y, T, 'linear', 'none');
T1 = scattered_interp(x_target, y_target);
time_elapsed(1) = toc;

%% 2. Metoda: griddedInterpolant
tic;
xq = 0:0.01:3.7; % 371 točk (dx = 0.01m)
yq = 0:0.01:2.4; % 241 točk (dy = 0.01m)
[Xq, Yq] = meshgrid(xq, yq);


T_grid = scattered_interp(Xq, Yq); 
grid_interp = griddedInterpolant({xq, yq}, T_grid', 'linear');
T2 = grid_interp(x_target, y_target);
time_elapsed(2) = toc;

%% 3. Metoda: Ročna interpolacija znotraj celice
tic;
T3 = manualInterpolation(celice, x, y, T, x_target, y_target);
time_elapsed(3) = toc;


[~, fastest_method] = min(time_elapsed);
fprintf('Časi izvajanja metod:\n');
fprintf('  ScatteredInterpolant: %.5fs\n', time_elapsed(1));
fprintf('  GriddedInterpolant: %.5fs\n', time_elapsed(2));
fprintf('  Ročna interpolacija: %.5fs\n', time_elapsed(3));
fprintf('Najhitrejša metoda je metoda %d\n', fastest_method);

% Največja temp.
[opt_xy, max_temp] = fminsearch(@(xy) -grid_interp(xy(1), xy(2)), [1, 1]);
fprintf('Največja temperatura: %.3f°C pri [x, y] = [%.3f, %.3f]\n', -max_temp, opt_xy(1), opt_xy(2));

% Interpolated
function T_interpolated = manualInterpolation(celice, x, y, T, x_target, y_target)
    T_interpolated = NaN;
    for idx = 1:size(celice, 1)
        
        vozlisca_celice = celice(idx, :);
        
        
        x1 = x(vozlisca_celice(1));
        x2 = x(vozlisca_celice(2));
        x3 = x(vozlisca_celice(3));
        x4 = x(vozlisca_celice(4));
        
        y1 = y(vozlisca_celice(1));
        y2 = y(vozlisca_celice(2));
        y3 = y(vozlisca_celice(3));
        y4 = y(vozlisca_celice(4));
        
        
        if (x1 <= x_target && x2 >= x_target) && (y1 <= y_target && y3 >= y_target)
            
            T11 = T(vozlisca_celice(1));
            T21 = T(vozlisca_celice(2));
            T12 = T(vozlisca_celice(4));
            T22 = T(vozlisca_celice(3));
            
            
            alpha_x = (x_target - x1) / (x2 - x1);
            alpha_y = (y_target - y1) / (y3 - y1);
            
            
            T_interpolated = (1 - alpha_x) * (1 - alpha_y) * T11 + ...
                             alpha_x * (1 - alpha_y) * T21 + ...
                             (1 - alpha_x) * alpha_y * T12 + ...
                             alpha_x * alpha_y * T22;
            break;
        end
    end
end