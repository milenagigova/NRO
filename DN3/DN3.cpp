// DN3.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>
#include <cmath>

double calcAtan(double* x, int* N_steps) {
    if (std::abs(*x) >= 1.0) { 
        std::cerr << "Napaka: Ne konvergira za |x| >= 1" << std::endl;
        return 0.0;
    }

    double rezult = 0.0; 
    double clen = *x;    
    for (int n = 0; n < *N_steps; ++n) {
        if (n > 0) {
            clen *= -(*x) * (*x); 
        }
        rezult += clen / (2 * n + 1); 
    }
    return rezult;
}

// f(x) = e^(3x) * arctan(x/2)
double f(double x, int N_steps) {
    double x_pola = x / 2.0;                
    double atan_x_pola = calcAtan(&x_pola, &N_steps); 
    return exp(3 * x) * atan_x_pola;        
}

// Trapezna metoda 
double trapezoidal(double a, double b, int n, int N_steps) {
    double h = (b - a) / n; 
    double integral = 0.0;

    for (int i = 0; i <= n; ++i) {
        double x = a + i * h; 
        double utez = (i == 0 || i == n) ? 1 : 2; 
        integral += utez * f(x, N_steps);
    }

    integral *= h / 2; 
    return integral;
}

int main() {
    double a = 0;                 //zgornja meja
    double b = std::atan(1.0);    // spodnja meja
    int n = 1000;                 // št. delitev 
    int N_steps = 20;             // št. èlenov T.V.

    // Izraèun 
    double rezult = trapezoidal(a, b, n, N_steps);

    // Rešitev
    std::cout << "Rešitev integrala: " << rezult << std::endl;

    return 0;
}

// Run program: Ctrl + F5 or Debug > Start Without Debugging menu
// Debug program: F5 or Debug > Start Debugging menu

// Tips for Getting Started: 
//   1. Use the Solution Explorer window to add/manage files
//   2. Use the Team Explorer window to connect to source control
//   3. Use the Output window to see build output and other messages
//   4. Use the Error List window to view errors
//   5. Go to Project > Add New Item to create new code files, or Project > Add Existing Item to add existing code files to the project
//   6. In the future, to open this project again, go to File > Open > Project and select the .sln file
