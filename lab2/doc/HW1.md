# HW1

## PB19000362 钟书锐

## Answer

### 如果将 Examples/typeid-s2.cpp 中的 printTypeinfo 函数的第 2 个参数的类型中的 B 改为 D，此时程序能否通过编译？为什么？

- 不能通过编译 error: invalid conversion from ‘B*’ to ‘const D*’
- 调用 printTypeinfo ,第二个参数是 &b,ptr,ptr2 的类型都是指向基类的指针。
- 将子类指针赋值给基类指针时，不需要进行强制类型转换，C++编译器将自动进行类型转换。因为子类对象也是一个基类对象。
- 将基类指针赋值给子类指针时，需要进行强制类型转换，C++编译器将不自动进行类型转换。因为基类对象不是一个子类对象。子类对象的自增部分是基类不具有的。
