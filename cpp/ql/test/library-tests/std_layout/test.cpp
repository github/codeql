
// AStd is a standard layout type
struct AStd {
  int x;
};

// BNonStd is NOT a standard layout type - not all members have the same access
// control
class BNonStd {
  int x;
public:
  int y;
};

// CNonStd is NOT a standard layout type - it has a virtual function
class CNonStd {
  virtual void f();
};

// DNonStd is NOT a standard layout type - it has a virtual base class
class DNonStd : public virtual AStd {};

// ENonStd is NOT a standard layout type - it has a data member of reference
// type
class ENonStd {
  int& xref;
};

// FStd is a standard layout type - all data members are standard layout types
class FStd {
  AStd a;
};

// GNonStd is NOT a standard layout type - contains a non-standard-layout member
class GNonStd {
  BNonStd b;
};

// HStd is a standard layout type - its base class is a standard layout type
struct HStd : AStd {};

// INonStd is NOT a standard layout type - its base class is not a standard
// layout type
struct INonStd : BNonStd {};

// JStd is a standard layout type
struct JStd {
  static int x;
};

// KStd is a standard layout type - base class has no non-static data members
struct KStd : JStd {};

// LStd is a standard layout type - only one base class has non-static data
// members
struct LStd : AStd, JStd {};

// MNonStd is NOT a standard layout type - more than one base class with
// non-static data members
struct MNonStd : AStd, FStd {};

// Instantiations of NMaybeStd may or may not be standard layout types,
// depending on the template parameter.
template<typename T>
struct NMaybeStd {
  T x;
};

// Instantiation NMaybeStd<AStd> is a standard layout type
NMaybeStd<AStd> nmaybestd_astd;

// Instantiation NMaybeStd<AStd> is a standard layout type
NMaybeStd<int> nmaybestd_int;

// Instantiation NMaybeStd<BNonStd> is NOT a standard layout type
NMaybeStd<BNonStd> nmaybestd_bnonstd;

// Instantiations of ONonStd cannot be standard layout types - regardless of the
// template parameter's type - since not all members have the same access
// control.
template<typename T>
struct ONonStd {
  T x;
private:
  T y;
};

// Therefore instantiation ONonStd<int> is NOT a standard layout type
ONonStd<int> ononstd_int;
