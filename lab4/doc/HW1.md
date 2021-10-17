# HW1

## PB19000362 钟书锐

## Answer

### 阅读 1-1

阅读 demo 中的 main.cpp、demoDriver.cpp、demoDriver.h，简要说明 Driver 是如何工作的。

- `Driver`类 包含 `bool trace_scanning;`
  `bool trace_parsing;`2 个成员分别决定是否输出词法分析详情和语法分析详情。
- main.cpp 首先根据 参数设置` trace_scanning`，`trace_parsing`，`print_ast `为真或假，以决定是否输出词法分析和语法分析和 AST。ps:如果参数-h，调用 print_help 后直接退出。
- `auto root = driver.parse(filename);`调用`driver`的`parse()`函数构造语法树。
- `parse()`首先设置`driver`的 file 成员为 main 传入的文件名。
- 然后调用 `scan_begin()`对文件判断是否能打开()或者将输入流切换为标准输入。同时通过`lexer.set_debug(trace_scanning);`设置是否输出详细词法分析。
- 然后调用`parser.set_debug_level(trace_parsing);`设置是否输出详细语法分析。之后使用`parser.parse();`进行语法分析。
- 最后使用`scan_end();`关闭文件，main 函数通过`print_ast`判断是否输出 AST 树。

### 问题 1-2

阅读并理解 demo 代码以及 Bison-Flex 协作的方式，目前的实现中并不强制 demo 语言程序包含 main 函数，而这不符合文档描述的语言规范。若在前端分析过程中就强制要求 demo 语言程序必须包含且只能包含一个 main 函数（也就是说把这个约束用语法定义来体现），应该如何修改词法语法定义？

- 不应该定义 main 为关键字，如下，否则'会导致标识符无法匹配 main

```
FuncDef: VOID MAIN LPARENTHESE RPARENTHESE Block{
    $$ = new SyntaxTree::FuncDef();
    $$->ret_type = SyntaxTree::Type::VOID;
    $$->name = "main";
    $$->body = SyntaxTree::Ptr<SyntaxTree::BlockStmt>($5);
    $$->loc = @$;
  }
  ;
```

- 导致`int main = 0;`无法识别

```
void main()
{
    int main = 0;
    return;
}

```

- 可以直接在语法分析时对函数名进行判定

```
FuncDef: VOID IDENTIFIER LPARENTHESE RPARENTHESE Block{
    $$ = new SyntaxTree::FuncDef();
    $$->ret_type = SyntaxTree::Type::VOID;
    $$->name = $2;
    if($2!="main")
    {
      std::cout<<"No main function"<<std::endl;
      exit(1);
    }

    $$->body = SyntaxTree::Ptr<SyntaxTree::BlockStmt>($5);
    $$->loc = @$;
  }
  ;
```
