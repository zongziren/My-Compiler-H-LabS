# HW2

## PB19000362 钟书锐

## Answer

### Q2.1

- Q: -nostdinc 选项的用处是什么？
- -nostdinc 不搜索默认路径头文件
- Q: 请列出 EduCoder 平台上 gcc C 程序默认的头文件查找路径
- `/usr/lib/gcc/x86_64-linux-gnu/5/include`
- `/usr/local/include`
- `/usr/lib/gcc/x86_64-linux-gnu/5/include-fixed`
- `/usr/include/x86_64-linux-gnu`
- `/usr/include `
- Q:如何在使用了-nostdinc 选项的同时使得上述命令编译通过? 请进一步说明通过的原因（不能修改源文件）
- `gcc -E -nostdinc -I /usr/include -I /usr/include/x86_64-linux-gnu -I /usr/lib/gcc/x86_64-linux-gnu/5/include sample-io.c -o sampleio.i`
- 查找 `gcc -E sample-io.c -o sampleio.i` 后的 sampleio.i 文件，发现需要的头文件在
  `/usr/include`,`/usr/include/x86_64-linux-gnu`,`/usr/lib/gcc/x86_64-linux-gnu/5/include`三个文件夹下。
- cpp 预处理时 头文件搜索顺序：
  (1) 由参数-I 指定的路径(指定路径有多个路径时，按指定路径的顺序搜索)(2) 然后找 gcc 的环境变量`C_INCLUDE_PATH`, `CPLUS_INCLUDE_PATH`, `OBJC_INCLUDE_PATH`(3) 再找内定目录

### Q2.2

- Q:-nostdlib 选项的用处是什么？
- 不连接系统标准启动文件和标准库文件，只把指定的文件传递给连接器。
- Q:请列出 EduCoder 平台上 gcc C 程序默认链接的库
- libc.a / libc.so (runtime 库)
- Q:如何在使用了-nostdlib 选项的同时使得上述命令编译通过？请进一步说明通过的原因（不能修改源文件）
- `gcc -nostdlib sample-io.c -o sample-io -Wl,/usr/lib/x86_64-linux-gnu/crt1.o /usr/lib/x86_64-linux-gnu/crti.o /usr/lib/x86_64-linux-gnu/crtn.o -lc`
- gcc 提供了-Wl 选项告诉编译器将后面的参数传递给链接器
- -lc:-lc,标准 C 库（C lib）
