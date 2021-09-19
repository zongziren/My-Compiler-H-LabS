#include <iostream>
#include <typeinfo>
using namespace std;
class B
{
public:
    virtual void fun() { cout << "base fun" << endl; }
};
class D : public B
{
public:
    void fun() { cout << "derived fun" << endl; }
};
void printTypeinfo(const char *n, const B *pb)
{
    cout << "typeid(*" << n << ") is " << typeid(*pb).name() << endl;
}
int main()
{
    B b;
    D d;
    B *ptr = new D;
    ptr->fun();
    B *ptr2 = new B;
    ptr2->fun();
    printTypeinfo("&b", &b);
    printTypeinfo("&d", &d);
    printTypeinfo("ptr", ptr);
    printTypeinfo("ptr2", ptr2);
    return 0;
}