# HW2

## PB19000362 钟书锐

## Answer

### 给 weak_ptr 赋值(转化成 weak_ptr)的 shared_ptr 称作管理该 weak_ptr 的 shared_ptr。如果该 shared_ptr 释放了，那么还可以通过它原来管理的 weak_ptr 去访问对象吗？请在 src/step2/test1.cpp 文件中构造样例来找到上述问题的答案，并将你的答案和对样例的分析写在 src/step2/answer.md 中。

- 不可以通过它原来管理的 weak_ptr 去访问对象
- `weak_ptr` 是为了配合 `shared_ptr` 而引入的一种智能指针，它指向一个由 `shared_ptr` 管理的对象而不影响所指对象的生命周期，也就是将一个 `weak_ptr` 绑定到一个 `shared_ptr` 不会改变 `shared_ptr` 的引用计数。不论是否有 `weak_ptr` 指向，一旦最后一个指向对象的 `shared_ptr` 被销毁，对象就会被释放。

```
int main()
{
    shared_ptr<int> pa(new int(5));
    weak_ptr<int> pb(pa);
    cout << "pa.use_count():" << pa.use_count() << endl;
    cout << "pb.use_count():" << pa.use_count() << endl;
    cout << *pb.lock() << endl;
    pa.reset();
    cout << "pa.use_count():" << pa.use_count() << endl;
    cout << "pb.use_count():" << pa.use_count() << endl;
    cout << *pb.lock() << endl; //segmentation fault
    return 0;
}
```

- 通过`use_count()`计数，输出都为 1，在`reset()`之前，`cout << *pb.lock() << endl;`正确输出，shared_ptr 释放之后，对象被释放，使用`cout << *pb.lock() << endl;` 报错`segmentation fault`。
