// Copyright (c) 2024 Vinichuk Timofey
#ifndef __BLOCK_GEMM_OMP_H
#define __BLOCK_GEMM_OMP_H

#include <vector>

std::vector<float> BlockGemmOMP(const std::vector<float>& a,
                                const std::vector<float>& b, int size);

#endif  // __BLOCK_GEMM_OMP_H
