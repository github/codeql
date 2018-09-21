int printf(const char*, ...);

struct NoisyInt
{
  NoisyInt(int value = 0) : m_value(value) { printf("constructor %d\n", m_value); }
  ~NoisyInt() { printf("destructor %d\n", m_value); }

  int m_value;
};

struct NoisyPair
{
  NoisyPair(int fst, int snd)
    : m_fst(fst)
    , m_snd(snd) {}
  NoisyPair() : NoisyPair(0, 0) {}
  
  NoisyInt m_fst, m_snd;
};

struct NoisyTriple : NoisyPair
{
  NoisyInt m_third;
};

class ArrayInt
{
	ArrayInt() {}
	~ArrayInt() {}

	NoisyInt m_array[10];
};

int main()
{
  NoisyTriple t;
}

class ArrayMemberInit
{
public:
	ArrayMemberInit() : xs{0,1,2,3} {} // initializer

private:
	int xs[4];
};

struct A {
  A(int);
};

struct B {
  B(int);
};

struct C {
  C(int);
};

struct MultipleBases : A, B, C {
  int x;
  int y;
  int z;

  MultipleBases() :
    z(5),
    B(1),
    x(3),
    A(0),
    C(2),
    y(4) {
  }
}; 

struct VB {
  VB();
  VB(int);
  ~VB();
};

struct VD : virtual VB {
};

struct VirtualAndNonVirtual : VD, VB {
  VirtualAndNonVirtual() {
  }
  ~VirtualAndNonVirtual() {
  }
};

struct AllYourVirtualBaseAreBelongToUs : VD, VirtualAndNonVirtual, virtual VB {
  AllYourVirtualBaseAreBelongToUs() :
    VB(5) {
  }
  ~AllYourVirtualBaseAreBelongToUs() {
  }
};