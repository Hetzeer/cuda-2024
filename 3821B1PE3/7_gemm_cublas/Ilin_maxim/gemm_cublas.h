// Copyright (c) 2025 Ilin Maxim
#ifndef __GEMM_CUBLAS_H
#define __GEMM_CUBLAS_H

#include <vector>

std::vector<float> GemmCUBLAS(const std::vector<float>& a,
                              const std::vector<float>& b, int size);

#endif  // __GEMM_CUBLAS_H
