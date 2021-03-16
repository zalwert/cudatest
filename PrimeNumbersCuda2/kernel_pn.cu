
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <list>
#include <stdio.h>
#include <string>
#include <iostream>

using namespace std;

cudaError_t addWithCuda(int *c, const int *a, const int *b, unsigned int size, const int h, int *p);

__global__ void addKernel(int *c, const int *a, const int *b, const int *h, int *p)
// musimy miec low, high i 
{
    printf("Hello, prime number will be generated from the gpu device!\n");

    int low = 0, ii;
    const int high = *h;
    bool isPrime = true;
    int pi = 0;
    int pp[20] = { 0 };




    for (int low = 0; low < high; low++) {

        if (low <= 1) {
            isPrime = false;
            continue;
        }
        else if (low == 3) {
            isPrime = true;
            p[pi] = low;
            pi = pi + 1;
            continue;
        }
        else if (low % 2 == 0 | low % 3 == 0) {
            isPrime = false;
            continue;
        }

        int iy = 5;

        for (int ii = iy; ii * ii <= low; ii++) {

            if (low % ii == 0 | low % (ii + 2) == 0) {
                isPrime = false;
                continue;
            }
            ii = ii + 6;
        }
        isPrime = true;
        p[pi] = low;
        pi = pi + 1;

    }




    //while (low < high) {
    //    isPrime = true;
    //    if (low == 0 || low == 1) {
    //        isPrime = false;
    //    }
    //    else {
    //        for (ii = 2; ii <= low / 2; ++ii) {
    //            if (low % ii == 0) {
    //                isPrime = false;
    //                break;
    //            }
    //        }
    //    }

    //    if (isPrime) {
    //        printf("%d\n", low);
    //        p[pi] = low;
    //       pi = pi + 1;
    //       //printf("print ", pi);
 
    //    }

    //    ++low;
    //}






    //p = pp;
    printf("kuk");
    int loop;
    for (loop = 0; loop < 20; loop++)
        printf("%d ", p[loop]);
    printf("kuk");

}


int main()
{
    const int arraySize = 5;
    const int a[arraySize] = { 1, 2, 3, 4, 5 };
    const int b[arraySize] = { 10, 20, 30, 40, 50 };
    int c[arraySize] = { 0 };
    const int high = 15;
    int p_main[20] = { 0 };

    // Add vectors in parallel.
    cudaError_t cudaStatus = addWithCuda(c, a, b, arraySize, high, p_main);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "addWithCuda failed!");
        return 1;
    }

    printf("{1,2,3,4,5} + {10,20,30,40,50} = {%d,%d,%d,%d,%d}\n",
        c[0], c[1], c[2], c[3], c[4]);

    // cudaDeviceReset must be called before exiting in order for profiling and
    // tracing tools such as Nsight and Visual Profiler to show complete traces.
    cudaStatus = cudaDeviceReset();
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaDeviceReset failed!");
        return 1;
    }

    // drukowanie listy prime
    printf("fffffffffffffffff");
    int loop;
    for (loop = 0; loop < 20; loop++)
        printf("%d ", p_main[loop]);
    printf("kuk");
    return 0;
}

// Helper function for using CUDA to add vectors in parallel.
cudaError_t addWithCuda(int *c, const int *a, const int *b, unsigned int size, const int h, int *p)
{
    int *dev_a = 0;
    int *dev_b = 0;
    int *dev_c = 0;
    int *hh = 0;
    int* pp = 0;
    cudaError_t cudaStatus;

    // Choose which GPU to run on, change this on a multi-GPU system.
    cudaStatus = cudaSetDevice(0);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaSetDevice failed!  Do you have a CUDA-capable GPU installed?");
        goto Error;
    }

    // Allocate GPU buffers for three vectors (two input, one output)    .
    cudaStatus = cudaMalloc((void**)&dev_c, size * sizeof(int));
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMalloc failed!");
        goto Error;
    }

    cudaStatus = cudaMalloc((void**)&dev_a, size * sizeof(int));
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMalloc failed!");
        goto Error;
    }

    cudaStatus = cudaMalloc((void**)&pp, 20 * sizeof(int));
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMalloc failed!");
        goto Error;
    }

    cudaStatus = cudaMalloc((void**)&dev_b, size * sizeof(int));
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMalloc failed!");
        goto Error;
    }

    cudaStatus = cudaMalloc((void**)&hh, sizeof(int));
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMalloc failed!");
        goto Error;
    }

    // Copy input vectors from host memory to GPU buffers.
    cudaStatus = cudaMemcpy(dev_a, a, size * sizeof(int), cudaMemcpyHostToDevice);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMemcpy failed!");
        goto Error;
    }

    cudaStatus = cudaMemcpy(dev_b, b, size * sizeof(int), cudaMemcpyHostToDevice);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMemcpy failed!");
        goto Error;
    }

    cudaStatus = cudaMemcpy(hh, &h, sizeof(int), cudaMemcpyHostToDevice);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMemcpy failed!");
        goto Error;
    }

    // Launch a kernel on the GPU with one thread for each element.
    addKernel<<<1, 1>>>(dev_c, dev_a, dev_b, hh, pp);

    // Check for any errors launching the kernel
    cudaStatus = cudaGetLastError();
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "addKernel launch failed: %s\n", cudaGetErrorString(cudaStatus));
        goto Error;
    }
    
    // cudaDeviceSynchronize waits for the kernel to finish, and returns
    // any errors encountered during the launch.
    cudaStatus = cudaDeviceSynchronize();
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaDeviceSynchronize returned error code %d after launching addKernel!\n", cudaStatus);
        goto Error;
    }

    // Copy output vector from GPU buffer to host memory.
    cudaStatus = cudaMemcpy(c, dev_c, size * sizeof(int), cudaMemcpyDeviceToHost);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMemcpy failed!");
        goto Error;
    }

    // Copy output vector from GPU buffer to host memory.
   cudaStatus = cudaMemcpy(p, pp, 20 * sizeof(int), cudaMemcpyDeviceToHost);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMemcpy failed!");
        goto Error;
    }

Error:
    cudaFree(dev_c);
    cudaFree(dev_a);
    cudaFree(dev_b);
    
    return cudaStatus;
}
