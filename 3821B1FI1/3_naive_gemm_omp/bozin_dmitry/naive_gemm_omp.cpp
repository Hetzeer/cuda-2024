// Copyright (c) 2024 Bozin Dmitry
#include "naive_gemm_omp.h"
#include <omp.h>
#include <iostream>
#include <random>
#include <cstdlib>
#include <chrono>


std::vector<float> NaiveGemmOMP(const std::vector<float>& a,
                                const std::vector<float>& b,
                                int n) {
    
    
    std::vector<float> result(n * n, 0.0f);

    #pragma omp parallel for collapse(2) schedule(static)
    for(int i = 0; i < n; ++i) {
        for(int j = 0; j < n; ++j) {
            float sum = 0.0f;
            
            #pragma omp simd
            for(int k = 0; k < n; ++k) {
                sum += a[i * n + k] * b[k * n + j];
            }
            result[i * n + j] = sum;
        }
    }

    return result;
}