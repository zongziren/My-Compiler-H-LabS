# HW1

## PB19000362 钟书锐

## Answer

### 问题 1-1. 请阅读 include/SyntaxTreePrinter.h 和 src/SyntaxTreePrinter.cpp，总结 VarDef、InitVal、LVal、FuncDef、FuncFParamList、FuncParam、BlockStmt 等节点类的结构及其 visit 方法的实现特点。

- VarDef：结构包含 `is_constant`，`btype`，`name`，`is_inited`，`array_length`，`initializers` 成员
- VarDef：visit 方法的实现特点 ：

  1. 首先通过 `is_constant` 判断是否输出 const。
  2. 通过`btype`和`name`成员输出对应的 变量类型和名称。
  3. 通过`array_length`判断是否输出'['']'，以及输出多少个。
  4. 在输出'['和']'之间，通过对 length 表达式的访问，输出 lenth 对应的表达式。

- InitVal：结构包含 isExp，elementList，expr;
- InitVal：visit 方法的实现特点 ：

  1. 通过`isExp`判断是否为表达式。
  2. 若为表达式，直接对表达式元素进行访问。
  3. 否则输出'{'，访问 elementList 每个元素，输出'}'。

- LVal: 结构包含 name，arry_index;
- LVal：visit 方法的实现特点 ：

  1. 通过 name 属性，输出变量名字。
  2. 通过 arry_index 输出'[' 和 ']' 以及里面的 index，若为空，不是数组，不输出此部分。

- FuncDef: 结构包含 name，ret_type，param_list，body。
- FuncDef：visit 方法的实现特点 ：

  1. 首先根据 ret_type 输'int' 或者 'float'。
  2. 输出空格后输出名字，再输出'('。
  3. 根据 param_list 输出参数列表，形如 int a，int b。
  4. 再输出'}'。
  5. 最后通过访问 body，输出函数体。

- FuncFParamList: 结构包含 params。
- FuncFParamList：visit 方法的实现特点 ：

  1. 对 parms 中每个 parm 分别输出
  2. 在每 2 个 parm 之间输出','。

- FuncParam： 结构包含 name，param_type，array_index。
- FuncParam：visit 方法的实现特点 ：

  1. 首先输出类型，如 int 。
  2. 输出变量名。
  3. 输出数组相关信息，此处与 lval 类似。

- BlockStmt：结构包含 body。
- BlockStmt：visit 方法的实现特点 ：
  1. 调用 ident 打印缩进。
  2. 输出'{'。
  3. ident+=4。
  4. 对 body 中每条语句输出。
  5. ident-=4。
  6. 调用 ident 打印缩进。
  7. 输出'}'。

### 问题 1-2. 熟悉本项目提供的 SysYF 解析器，编译运行它，用它处理 SysYF 程序，输出语法树。

- `./sysYFParser -emit-ast ../testcase.sy`
- 输出：`int a = (2%3);`

### 问题 3-1. 请提交一份实验总结，该实验总结必须包含以下内容：

- 你在实验过程中遇到的困难与解决方案

  1. 困难：最初采用进入 BlockStmt 时 `enter_scope();`，离开时 `exit_scope();`,导致对于形式参数在函数体的顶层作用域内没有很好实现，即导致类似如下代码无法报错。

  ```
  int f(int a)
  {
      int a;
  }
  ```

  2. 解决：引入`bool funcdef_flag = 0;`，在 FuncDef 的时候设置为 1，同时`enter_scope();`的时机变为访问 FuncDef 的时候。在访问 BlockStmt 的时候根据`funcdef_flag`判断是否需要`enter_scope()`。

- 你认为的实验难点与考察倾向

  1. 难点：理解访问者模式 和 作用域。
  2. 考察倾向：建立符号表存储函数变量定义的信息。管理符号表栈实现对作用域的区分。

- 你的整体实现思路与实现亮点

  1. 对访问者加入三个 public 变量，分别用来区分函数定于的 blockstmt，作为存储符号表的栈，作为存储函数参数信息的 map。

  ```
    bool funcdef_flag = 0;
    std::vector<std::map<std::string, SyntaxTree::Type>> typedicts;
    std::map<std::string, SyntaxTree::FuncFParamList> funcdicts;
  ```

  2. 定义 2 个函数`enter_scope()`和`void exit_scope()`，分别负责进入一个作用域时，创建一个用来存储作用域内变量信息的 map 压入栈，离开作用域时出栈栈顶的 map。

  ```
    void enter_scope()
    {
    std::map<std::string, SyntaxTree::Type> typedict;
    typedicts.push_back(typedict);
    }

    void exit_scope()
    {
    typedicts.pop_back();
    }
  ```

  3. 在函数定义和变量定义时，把相关信息存储在栈顶元素 map 之中，如果已经在栈顶存在就报错重复定义信息。特别是函数定义，同时把参数信息存入`funcdicts`。

  4. 对变量的访问和函数的调用时，从栈顶的 map 向下依次查询 name，如果整个栈访问完毕，没有查到就报错未定义信息。特别是函数调用，同时要比较传入参数的个数类型是否和`funcdicts`之中存储的类型一致。

### 问题 3-2. 试回答：处理变量声明时，是应该先处理变量的初始化还是先把该变量加入符号表？处理函数定义时，是先处理函数体还是先把函数名加入符号表？

1. 处理变量声明时，先处理变量的初始化，再把该变量加入符号表。以防出现 `int a = a;`之类的语句通过类型检查。
2. 处理函数定义时，先把函数名加入符号表，再处理函数体，否则递归调用无法实现。

### 问题 3-3. 有人说如果本次实验允许修改抽象语法树的话，他想给 Expr 添加一个属性用于判断是否为整数，而不是在 SyntaxTreeChecker 内部设置该属性。这种做法有什么缺点？另一个人说，完成本次实验后 SyntaxTreeChecker 类过于庞大了，他想拆成多个类，每个类处理一种可能的语义错误，这种做法又有什么缺点

1. 给 Expr 添加一个属性用于判断是否为整数，缺点：语法树增加了额外的内存空间的开销，每个 expr 结点都要增加一定内存空间开销。
2. 拆成多个类，缺点：每一次 check 对每一种错误都要遍历一次语法树，花费了更多的时间，要多次遍历语法树。

### 问题 3-4.如果想给错误人为地规定一个优先级，例如，如果取模运算是最高优先级，那么语义检查器在遇到存在取模运算错误的程序时，必定报取模运算错误，也即 ErrorType::Module。对于如下程序将报错 ErrorType::Module，试谈一下你的实现思路。

```
int f(int x)
{
return 0;
}
int main(){
int a = f(0.1);
return a % 0.1;
}

```

1. check 的时候遇到错误，不退出，存储错误类型和相应位置在错误表中，然后继续进行检查，直到最后检查完毕。
