#include <iostream>
#include <typeinfo>
using namespace std;
class Base
{
public:
    Base(){};
    virtual void Show() { cout << "This is Base calss"; }
};
class Derived : public Base
{
public:
    Derived(){};
    void Show() { cout << "This is Derived class"; }
};
int main()
{
    /*dynamic_cast和类*/
    cout << "dynamic_cast和类&继承" << endl;
    /*dynamic_cast向上转换*/
    Derived *der0 = new Derived;
    Base *base0 = dynamic_cast<Base *>(der0);
    cout << "Base *base0 = dynamic_cast<Base *>(der0)转换成功:" << endl;
    base0->Show();
    cout << endl;
    /*dynamic_cast向下转换*/
    /*case1*/
    Base *base1 = new Derived;
    if (Derived *der1 = dynamic_cast<Derived *>(base1))
    {
        cout << "Derived *der1 = dynamic_cast<Derived *>(base1)转换成功:" << endl;
        der1->Show();
        cout << endl;
    }
    /*case2*/
    Base *base2 = new Base;
    if (Derived *der2 = dynamic_cast<Derived *>(base2))
    //对指针进行dynamic_cast，失败返回null，成功返回正常cast后的对象指针；
    {
        cout << "Derived *der2 = dynamic_cast<Derived *>(base2)转换成功:" << endl;
        der2->Show();
        cout << endl;
    }
    else
    {
        cout << "Derived *der2 = dynamic_cast<Derived *>(base2)转换失败。" << endl;
    }
    cout << endl;
    /*dynamic_cast和引用类型*/
    cout << "dynamic_cast和类&引用" << endl;
    /*dynamic_cast向上转换*/
    Derived a;
    Derived &der3 = a;
    Base &base3 = dynamic_cast<Base &>(der3);
    cout << "Base &base3 = dynamic_cast<Base *>(der3)转换成功:" << endl;
    base3.Show();
    cout << endl;
    /*dynamic_cast向下转换*/
    /*caase1*/
    Derived b;
    Base &base4 = b;
    Derived &der4 = dynamic_cast<Derived &>(base4);
    cout << "Derived &der4 = dynamic_cast<Derived &>(base4)转换成功:" << endl;
    der4.Show();
    cout << endl;
    /*case2*/
    Base c;
    Base &base5 = c;
    try
    {
        Derived &der5 = dynamic_cast<Derived &>(base5);
        //对引用进行dynamic_cast，失败抛出一个异常，成功返回正常cast后的对象引用。
    }
    catch (bad_cast)
    {
        cout << "Derived &der5 = dynamic_cast<Derived &>(base5)转化失败,抛出bad_cast异常。" << endl;
    }

    // 基本类型和指针静态转换
    char char1_ = 'c';
    int int_ = static_cast<int>(char1_);
    char char2_ = static_cast<char>(int_);
    cout << "char1_= " << char1_ << endl;
    cout << "int_= " << int_ << endl;
    cout << "char2_= " << char2_ << endl;
    char *pchar1_ = &char1_;
    int *pint_ = (int *)pchar1_;
    //int *pint_ = static_cast<int*>(pchar1_);      //error
    //pchar1_ = static_cast<char*>(pint_);          //error
    char *pchar2_ = (char *)pint_;
    //char *pchar2_ = static_cast<char*>(pint_);    //error
    cout << "pchar1_= " << *pchar1_ << endl;
    cout << "pint_= " << pint_ << endl;
    cout << "pchar2_= " << *pchar2_ << endl;
    void *p0 = static_cast<void *>(pchar1_);
    int *p1 = static_cast<int *>(p0);
    char *p2 = static_cast<char *>(p0);
    cout << "p0= " << p0 << endl;
    cout << "p1= " << p1 << endl;
    cout << "p2= " << *p2 << endl;

    //类层次中基类与子类相关静态转换
    //指针或引用静态转换
    Base base_;
    Derived derived_;
    base_ = static_cast<Base &>(derived_); //转换为基类引用
    base_ = static_cast<Base>(derived_);   //转换为基类
    //derived_ = static_cast<Derived>(base_);       //error

    Base *pbase1 = new Base;
    Derived *pderived1 = new Derived;
    pbase1 = static_cast<Base *>(pderived1); //基类指针指向子类
    //pderived1 = pbase1;                           //error
    pderived1 = static_cast<Derived *>(pbase1); //基类指针强制转换为子类指针

    return 0;
}