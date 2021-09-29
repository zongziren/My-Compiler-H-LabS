#include <iostream>
#include <memory>
int main()
{
    auto x = new int(0);
    std::shared_ptr<int> sptr1(x);
    {
        std::weak_ptr<int> sptr2 = sptr1;
        auto sptr3 = sptr1;
        std::cout << sptr1.use_count();
    }
    std::cout << sptr1.use_count();
}