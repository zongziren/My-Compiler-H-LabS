# HW3

## PB19000362 钟书锐

## Answer

### Q3.1:BasicBlock::print 函数 62-73 行的 for 循环在整个程序中的作用是什么？这段代码的什么地方用到了 RTTI 机制？

- 在整个程序中的作用：统计程序块内部的一个操作数和两个操作数的指令分别有多少个，如果有不支持指令，报错并中止程序执行。

- 什么地方用到了 RTTI 机制：v 的类型是指向 value 类的指针，如果在赋值时使用了`new UnaryInst()`，则 v 指向一个 UnaryInst 类，此时使用 dynamic_cast 进行向下转型时，会进行运行时检查（RTTI 机制），`dynamic_cast<UnaryInst *>(v)`成功。`dynamic_cast<BinaryInst *>(v)`失败，返回 nulptr。以实现统计 2 种指令的个数。

### Q3.2:如果没有 RTTI 机制（部分库会在编译时加上 fno-rtti 选项，因为 RTTI 会带来一定的开销），为了保持功能的一致性，应该如何实现 BasicBlock::print 函数？请在 answer.md 中简要描述你的思路。

- 可以利用 value 类的 name 属性判断，调用 v->getname()，如果返回 "BinaryInst"，`binary_cnt++`。如果是"UnaryInst"，`unary_cnt++`。如果是其它，`std::cerr << "Unspported instruction: " << v->getName() << std::endl;abort();`

### Q3.3:在第二问的前提下，如果 Instruction 有很多个子类（不同的指令），而且以后还会扩充现在不知道叫什么名字的新指令（这里的新指令是 Instruction 的直接子类），应该怎么实现 BasicBlock::print 函数？请在 answer.md 中简要描述你的思路并在 static_cast.cpp 中实现，要求输出与第一问一致（提示：可以对该程序进行任何修改）。

- 使用 map 键值对容器`std::map<std::string, int> mapinst`，对读入的 v 的`v->getname()`作为 key 值查找。如果查找失败，inset 新的键值对`(v->getName(), 1)`，如果查找成功,对应的 value++。输出时直接用迭代器输出键值对`std::cout << it->second << ' ' << it->first << std::endl;`

### Q3.4:编译运行 type-id.cpp 程序并解释输出。

- 输出

```
P5Value
10BasicBlock
P11Instruction
10BinaryIns
```

- 当 typeid 运算符应用在一个指向多态类型对象的指针上的时候，typeid 的实现才需要有运行时行为
- v 的类型是指向 value 类的指针，类型为(\*value)，所以 typeid 显示`P5Value`。
- 赋值后 v 指向一个 BasicBlock 类，typeid(\*v)进行类型推断，获得其运行时类型为`10BasicBlock`。
- inst 和 v 相同。

### Q3.5:当去掉 Instruction 类的父类 Value（删除: public Value）时，程序的输出是什么？对输出进行解释

- 输出

```
P5Value
10BasicBlock
P11Instruction
11Instruction
```

- v 相关输出同上。
- C++规范并没有规定虚函数的实现方式。不过大部分 C++实现都用虚函数表（vtable）来实现虚函数的分派。
- typeinfo 通常存储在虚函数表（vtable）中，typeid 必须借助 虚函数表（访问其中的 typeinfo 信息） 来实现类型推断。
- 此时,Instruction 为基类,BinaryInst 是 Instructin 的子类。但是 Instruction 没有虚函数。
- Instruction 类中并不存在虚函数表，当没有虚函数表指针时，编译器就静态处理 typeid()，在编译时就能够确定操作数的类型。所以`std::cout << typeid(*inst).name() << std::endl;`输出`11Instruction`。
