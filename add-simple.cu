#include <stdio.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

__global__ void vector_add(const int *a, const int *b, int *c) {
    *c = *a + *b;
}

int main(void) {
    // mem op starts
    int a, b, c;
    printf("a = "); scanf("%d", &a);
    printf("b = "); scanf("%d", &b);
    // mem op ends

    // gmem op starts
    int *dev_a, *dev_b, *dev_c;
    cudaMalloc((void **)&dev_a, sizeof(int));
    cudaMalloc((void **)&dev_b, sizeof(int));
    cudaMalloc((void **)&dev_c, sizeof(int));
    cudaMemcpy(dev_a, &a, sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(dev_b, &b, sizeof(int), cudaMemcpyHostToDevice);
    vector_add <<<1, 1>>> (dev_a, dev_b, dev_c);
    cudaMemcpy(&c, dev_c, sizeof(int), cudaMemcpyDeviceToHost);
    cudaFree(dev_a);
    cudaFree(dev_b);
    cudaFree(dev_c);
    // gmem op ends

    printf("c = %d + %d = %d\n", a, b, c);
    return 0;
}

