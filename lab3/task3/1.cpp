#include <iostream>
#include <memory>
class A
{
public:
    ~A() { std::cout << "H"; }
};
int main()
{
    {
        std::unique_ptr<A> uptr(new A());
        std::unique_ptr<A> uptr2 = std::move(uptr);
        uptr2.release();
        // L17
    }
    // L19
}