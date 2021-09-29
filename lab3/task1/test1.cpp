#include <iostream>
#include <memory>
#include <cassert>
using namespace std;
void func(auto_ptr<int> ap)
{
    return;
}
int main()
{
    int a = 1;
    auto_ptr<int> ap(&a);
    cout << a << endl;
    cout << *(ap.get()) << endl;
    func(ap);
    //将std::auto_ptr按值传递给函数导致资源转移至函数参数
    //在函数末尾(超出函数参数的作用域)被销毁
    cout << *(ap.get()) << endl;
    //访问std::auto_ptr 参数时,这时已是空引用指针
    return 0;
}
