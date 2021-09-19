#include <iostream>
#include <typeinfo>
using namespace std;
class Base
{
public:
    virtual ~Base() {}
};
class Derived : public Base
{
};
int main()
{
    Derived derived;
    Base *ptr = &derived;
    cout << typeid(ptr).name() << endl;
    cout << typeid(*ptr).name() << endl;
    return 0;
}