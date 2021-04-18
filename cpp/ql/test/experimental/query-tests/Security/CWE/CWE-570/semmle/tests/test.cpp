#define NULL ((void*)0)
class exception {};

namespace std{
  struct nothrow_t {};
  typedef unsigned long size_t;
  class bad_alloc{
    const char* what() const throw();
  };
  extern const std::nothrow_t nothrow;
}

using namespace std;

void* operator new(std::size_t _Size);
void* operator new[](std::size_t _Size);
void* operator new( std::size_t count, const std::nothrow_t& tag ) noexcept;
void* operator new[]( std::size_t count, const std::nothrow_t& tag ) noexcept;

void badNew_0_0()
{
    while (true) {
        new int[100]; // BAD [NOT DETECTED]
        if(!(new int[100])) // BAD [NOT DETECTED]
            return;
    }
}
void badNew_0_1()
{
    int * i = new int[100]; // BAD
    if(i == 0)
        return;
    if(!i)
        return;
    if(i == NULL)
        return;
    int * j;
    j = new int[100]; // BAD
    if(j == 0)
        return;
    if(!j)
        return;
    if(j == NULL)
        return;
}
void badNew_1_0()
{
    try {
        while (true) {
            new(std::nothrow) int[100]; // BAD
            int* p = new(std::nothrow) int[100]; // BAD
            int* p1;
            p1 = new(std::nothrow) int[100]; // BAD
        }
    } catch (const exception &){//const std::bad_alloc& e) {
//        std::cout << e.what() << '\n';
    }
}
void badNew_1_1()
{
    while (true) {
        int* p = new(std::nothrow) int[100]; // BAD [NOT DETECTED]
        new(std::nothrow) int[100]; // BAD [NOT DETECTED]
    }
}

void goodNew_0_0()
{
    try {
        while (true) {
            new int[100]; // GOOD
        }
    } catch (const exception &){//const std::bad_alloc& e) {
//        std::cout << e.what() << '\n';
    }
}

void goodNew_1_0()
{
    while (true) {
        int* p = new(std::nothrow) int[100]; // GOOD
        if (p == nullptr) {
//            std::cout << "Allocation returned nullptr\n";
            break;
        }
        int* p1;
        p1 = new(std::nothrow) int[100]; // GOOD
        if (p1 == nullptr) {
//            std::cout << "Allocation returned nullptr\n";
            break;
        }
        if (new(std::nothrow) int[100] == nullptr) { // GOOD
//            std::cout << "Allocation returned nullptr\n";
            break;
        }
    }
}
