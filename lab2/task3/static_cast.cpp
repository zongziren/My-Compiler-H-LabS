#include <iostream>
#include <list>
#include <string>
#include <cassert>
#include <map>

class Value
{
public:
    Value()
    {
        setName("Value");
    }
    virtual ~Value() {}
    void setName(std::string n)
    {
        name = n;
    }
    std::string getName()
    {
        return name;
    }
    virtual void print()
    {
        std::cout << "I'm a " << getName() << std::endl;
    }

protected:
    std::string name;
};

class Instruction : public Value
{
public:
    Instruction()
    {
        setName("Instruction");
    }
    virtual void print() override
    {
        std::cout << getName() << std::endl;
    }
};

class UnaryInst : public Instruction
{
public:
    UnaryInst()
    {
        setName("UnaryInst");
    }
};

class BinaryInst : public Instruction
{
public:
    BinaryInst()
    {
        setName("BinaryInst");
    }
};

class BasicBlock : public Value
{
public:
    BasicBlock()
    {
        setName("BasicBlock");
    }
    ~BasicBlock()
    {
        for (auto v : values)
        {
            delete v;
        }
    }
    virtual void print() override
    {
        std::map<std::string, int> mapinst;
        int unary_cnt = 0, binary_cnt = 0;
        std::map<std::string, int>::iterator l_it;
        for (auto v : values)
        {
            l_it = mapinst.find(v->getName());
            if (l_it == mapinst.end())
                mapinst.insert(std::map<std::string, int>::value_type(v->getName(), 1));
            else
                l_it->second++;
        }
        std::map<std::string, int>::iterator it;
        std::map<std::string, int>::iterator itEnd;
        std::cout << name << ": " << std::endl;
        it = mapinst.begin();
        itEnd = mapinst.end();
        while (it != itEnd)
        {
            std::cout << it->second << ' ' << it->first << std::endl;
            it++;
        }
        std::cout << std::endl;
        for (auto v : values)
        {
            std::cout << "  " << v->getName() << std::endl;
        }
    }
    void addValue(Value *v)
    {
        values.push_back(v);
    }

private:
    std::list<Value *> values;
};

int main()
{
    BasicBlock *bb = new BasicBlock();
    bb->addValue(new UnaryInst());
    bb->addValue(new UnaryInst());
    bb->addValue(new BinaryInst());
    bb->addValue(new UnaryInst());
    bb->addValue(new BinaryInst());
    bb->print();
    delete bb;
    return 0;
}