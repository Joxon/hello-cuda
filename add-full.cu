/*
* 为了方便起见，我甚至把一些出错判断都去掉了。
* 比如申请内存空间，谁都没法保证内存一定有空间给你申请的不是吗？
* 之所以这样，是为了方便我们看清楚一个基本的cuda程序的执行流程。
*/
#include <stdio.h>

/*
* 这个是要放在显卡上面跑的函数，除了前面多了一个__global__之外，
* 这个函数其实很简单不是吗？
*/
__global__ void vector_add(const int *a, const int *b, int *c) {
    *c = *a + *b;
}

int main(void) {
    //这里定义了三个整形变量a，b和c。他们位于主存上。
    const int a = 2, b = 5;
    int c = 0;

    //这里定义了三个整形指针。为什么要用指针？
    //因为这是在显存上申请空间，对于主机来说，它只能也只需要知道一个映射的地址就够了。
    int *dev_a, *dev_b, *dev_c;

    //为三个指针申请显存空间，虽然只是一个int，4个字节的大小。
    cudaMalloc((void **)&dev_a, sizeof(int));
    cudaMalloc((void **)&dev_b, sizeof(int));
    cudaMalloc((void **)&dev_c, sizeof(int));

    //将内存上的数据复制到显存上，这里复制了a和b两个加数。
    cudaMemcpy(dev_a, &a, sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(dev_b, &b, sizeof(int), cudaMemcpyHostToDevice);

    //调用那个要在显卡上面执行的函数。还记得main前面的那个函数么？
    vector_add << <1, 1 >> > (dev_a, dev_b, dev_c);

    //这里把dev_c上面的值复制到内存的变量c上。
    cudaMemcpy(&c, dev_c, sizeof(int), cudaMemcpyDeviceToHost);

    //输出结果
    printf("%d + %d = %d, Is that right?\n", a, b, c);

    //释放显存
    cudaFree(dev_a);
    cudaFree(dev_b);
    cudaFree(dev_c);

    return 0;
}

