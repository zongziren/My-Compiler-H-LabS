#include <iostream>
#include <memory>
using namespace std;

int main()
{
    int *p = new int(5);
    shared_ptr<int> pa(p);
    shared_ptr<int> pa1(pa);
    weak_ptr<int> pb(pa);
    cout << "pa.use_count():" << pa.use_count() << endl;
    cout << "pa1.use_count():" << pa1.use_count() << endl;
    cout << "pb.use_count():" << pa.use_count() << endl;
    cout << *pb.lock() << endl;
    pa.reset();
    cout << "pa.use_count():" << pa.use_count() << endl;
    cout << "pa1.use_count():" << pa1.use_count() << endl;
    cout << "pb.use_count():" << pb.use_count() << endl;
    cout << *pb.lock() << endl; //segmentation fault
    return 0;
}