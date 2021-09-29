#include <iostream>
#include <memory>
#include <cassert>
using namespace std;
void func(unique_ptr<int> &a)
{
    return;
}

int main()
{
    unique_ptr<int> ap(new int(1));
    cout << *(ap.get()) << endl;
    func(ap);
    return 0;
}
