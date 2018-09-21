// semmle-extractor-options: -std=c++17
typedef unsigned long size_t;
namespace std {
  enum class align_val_t : size_t {};
}

void* operator new(size_t, float);
void* operator new[](size_t, float);
void* operator new(size_t, std::align_val_t, float);
void* operator new[](size_t, std::align_val_t, float);
void operator delete(void*, float);
void operator delete[](void*, float);
void operator delete(void*, std::align_val_t, float);
void operator delete[](void*, std::align_val_t, float);

struct String {
  String();
  String(const String&);
  String(String&&);
  String(const char*);
  ~String();

  String& operator=(const String&);
  String& operator=(String&&);

  const char* c_str() const;

private:
  const char* p;
};

struct SizedDealloc {
  char a[32];
  void* operator new(size_t);
  void* operator new[](size_t);
  void operator delete(void*, size_t);
  void operator delete[](void*, size_t);
};

struct alignas(128) Overaligned {
  char a[256];
};

struct PolymorphicBase {
  virtual ~PolymorphicBase();
};

void OperatorNew() {
  new int;  // No constructor
  new(1.0f) int;  // Placement new, no constructor
  new int();  // Zero-init
  new String();  // Constructor
  new(1.0f) String("hello");  // Placement new, constructor with args
  new Overaligned;  // Aligned new
  new(1.0f) Overaligned();  // Placement aligned new
}

void OperatorDelete() {
  delete static_cast<int*>(nullptr);  // No destructor
  delete static_cast<String*>(nullptr);  // Non-virtual destructor, with size.
  delete static_cast<SizedDealloc*>(nullptr);  // No destructor, with size.
  delete static_cast<Overaligned*>(nullptr);  // No destructor, with size and alignment.
  delete static_cast<PolymorphicBase*>(nullptr);  // Virtual destructor
  delete static_cast<const String*>(nullptr);  // Pointer to const
}

void OperatorNewArray(int n) {
  new int[n];  // No constructor
  new(1.0f) int[n];  // Placement new, no constructor
  new String[n];  // Constructor
  new Overaligned[n];  // Aligned new
  new String[10];  // Constant size
}

int* const GetPointer();

void OperatorDeleteArray() {
  delete[] static_cast<int*>(nullptr);  // No destructor
  delete[] static_cast<String*>(nullptr);  // Non-virtual destructor, with size.
  delete[] static_cast<SizedDealloc*>(nullptr);  // No destructor, with size.
  delete[] static_cast<Overaligned*>(nullptr);  // No destructor, with size and alignment.
  delete[] static_cast<PolymorphicBase*>(nullptr);  // Virtual destructor
  delete[] GetPointer();
}

struct FailedInit {
  FailedInit();
  ~FailedInit();

  void* operator new(size_t);  // Non-placement
  void* operator new[](size_t);  // Non-placement
  void operator delete(void*, size_t);  // Sized deallocation
  void operator delete[](void*, size_t);  // Sized deallocation
};

struct alignas(128) FailedInitOveraligned {
  FailedInitOveraligned();
  ~FailedInitOveraligned();

  void* operator new(size_t, std::align_val_t, float);  // Aligned placement
  void* operator new[](size_t, std::align_val_t, float);  // Aligned placement
  void operator delete(void*, std::align_val_t, float);  // Aligned placement
  void operator delete[](void*, std::align_val_t, float);  // Aligned placement
};

void TestFailedInit(int n) {
  new FailedInit();
  new FailedInit[n];
  new(1.0f) FailedInitOveraligned();
  new(1.0f) FailedInitOveraligned[10];
}
