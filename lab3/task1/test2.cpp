#include <iostream>
#include <memory>
#include <cassert>
using namespace std;
int main()
{
    int *p1 = new int[10];
    auto_ptr<int> p2(p1);
    return 0;
    //std::auto_ptr始终使用非数组的delete来删除其指向的元素
    //删除数组应该用delete[]
}