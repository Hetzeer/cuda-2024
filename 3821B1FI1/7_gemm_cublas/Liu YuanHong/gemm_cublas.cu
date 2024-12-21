#include "gemm_cublas.h"
#include <cublas_v2.h>
#include <cuda.h>
#include <cuda_runtime.h>
#include <iostream>
#include <vector>

std::vector<float> GemmCUBLAS(const std::vector<float>& a,
                              const std::vector<float>& b, int n) {
    std::vector<float> c(n * n);

    size_t sizeInBytes = n * n * sizeof(float);

    float* device_a;
    float* device_b;
    float* device_c;

    if (cudaMalloc(&device_a, sizeInBytes) != cudaSuccess) {
        std::cerr << "Error allocating device memory for A" << std::endl;
        return c;
    }
    if (cudaMalloc(&device_b, sizeInBytes) != cudaSuccess) {
        std::cerr << "Error allocating device memory for B" << std::endl;
        cudaFree(device_a);
        return c;
    }
    if (cudaMalloc(&device_c, sizeInBytes) != cudaSuccess) {
        std::cerr << "Error allocating device memory for C" << std::endl;
        cudaFree(device_a);
        cudaFree(device_b);
        return c;
    }

    if (cudaMemcpy(device_a, a.data(), sizeInBytes, cudaMemcpyHostToDevice) != cudaSuccess) {
        std::cerr << "Error copying A to device" << std::endl;
        cudaFree(device_a);
        cudaFree(device_b);
        cudaFree(device_c);
        return c;
    }
    if (cudaMemcpy(device_b, b.data(), sizeInBytes, cudaMemcpyHostToDevice) != cudaSuccess) {
        std::cerr << "Error copying B to device" << std::endl;
        cudaFree(device_a);
        cudaFree(device_b);
        cudaFree(device_c);
        return c;
    }

    cublasHandle_t handle;
    if (cublasCreate(&handle) != CUBLAS_STATUS_SUCCESS) {
        std::cerr << "Error creating cuBLAS handle" << std::endl;
        cudaFree(device_a);
        cudaFree(device_b);
        cudaFree(device_c);
        return c;
    }

    const float alpha = 1.0f;
    const float beta = 0.0f;

    cublasSetMathMode(handle, CUBLAS_TF32_TENSOR_OP_MATH);

    if (cublasGemmEx(handle, CUBLAS_OP_N, CUBLAS_OP_N, n, n, n,
                     &alpha, device_b, CUDA_R_32F, n,
                     device_a, CUDA_R_32F, n,
                     &beta, device_c, CUDA_R_32F, n,
                     CUBLAS_COMPUTE_32F_FAST_16F, CUBLAS_GEMM_DEFAULT) != CUBLAS_STATUS_SUCCESS) {
        std::cerr << "Error in cuBLAS matrix multiplication" << std::endl;
    }

    if (cudaMemcpy(c.data(), device_c, sizeInBytes, cudaMemcpyDeviceToHost) != cudaSuccess) {
        std::cerr << "Error copying C from device to host" << std::endl;
    }

    cudaFree(device_a);
    cudaFree(device_b);
    cudaFree(device_c);
    cublasDestroy(handle);

    return c;
}
