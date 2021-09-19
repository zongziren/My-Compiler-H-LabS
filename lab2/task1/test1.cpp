#include <iostream>
#include <typeinfo>
#include <vector>
using namespace std;
typedef int (*func_ptr)(int);

class Base
{
public:
    virtual void fun() { cout << "base fun" << endl; }
};
class Derived : public Base
{
public:
    void fun() { cout << "derived fun" << endl; }
};

int func(int a)
{
    return 0;
}

int main()
{
    std::string string_;

    int array[10] = {1};
    int *array_header = array;

    Base b, *pb;
    pb = NULL;
    Derived d;

    func_ptr f = func;
    vector<int> int_vector;

    cout << "int is of type " << typeid(int).name() << endl;
    cout << "unsigned is of type " << typeid(unsigned).name() << endl;
    cout << "long is of type " << typeid(long).name() << endl;
    cout << "unsigned long is of type " << typeid(unsigned long).name() << endl;
    cout << "char is of type " << typeid(char).name() << endl;
    cout << "unsigned char is of type " << typeid(unsigned char).name() << endl;
    cout << "long long is of type" << typeid(long long).name() << endl;
    cout << "float is of type " << typeid(float).name() << endl;
    cout << "double char is of type " << typeid(double).name() << endl;
    cout << "string is of type " << typeid(string_).name() << endl;
    cout << "int_arry is of type " << typeid(array).name() << endl;
    cout << "int_arry_header is of type " << typeid(array_header).name() << endl;
    cout << "b is of type " << typeid(b).name() << endl;
    cout << "Base type is of type " << typeid(Base).name() << endl;
    cout << "pb is of type " << typeid(pb).name() << endl;
    cout << "d is of type " << typeid(Derived).name() << endl;
    cout << "Derived type is of type " << typeid(d).name() << endl;
    cout << "func_ptr type is of type " << typeid(f).name() << endl;
    cout << "int_vec type is of type " << typeid(int_vector).name() << endl;
    cout << "type_info is of type " << typeid(type_info).name() << endl;
    return 0;
}
