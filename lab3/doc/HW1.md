# HW1

## PB19000362 钟书锐

## Answer

### 你认为 uniqu_ptr 可以作为实参传递给函数吗，为什么？请将你的思考放在 src/step1/文件夹下，并且命名为 answer.md。Hint: 从值传递和引用传递两方面考虑。

- void func(unique_ptr<int> &ap)
- 值传递：需要使用 `move()`，`func(std::move(ap))`，`unique_ptr`不可拷贝和赋值，只可以移动，所以需要显示的使用`move(ap)`作为值传递给函数。
- 引用传递：传引用，所以不必要担心该指针会被复制，可以直接传递`func(ap)`.
