#include <iostream>
int main()
{
    int m = 100;
    long n = static_cast<long>(m);                          //宽转换，没有信息丢失
    char ch = static_cast<char>(m);                         //窄转换，可能会丢失信息
    int *p1 = static_cast<int *>(malloc(10 * sizeof(int))); //将void指针转换为具体类型指针
    void *p2 = static_cast<void *>(p1);                     //将具体类型指针，转换为void指针
    //下面的用法是错误的
    /*
    float *p3 = static_cast<float *>(p1); //不能在两个具体类型的指针之间进行转换
    p3 = static_cast<float *>(100);       //不能将整数转换为指针类型
    */
    return 0;
}
