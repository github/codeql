// NOT OK
struct CopyButNoAssign {
  CopyButNoAssign() : n(0) {}
  CopyButNoAssign(const CopyButNoAssign& copy_from) : n(copy_from.n) {}
  int n;
};

// NOT OK
struct AssignButNoCopy {
  AssignButNoCopy& operator=(const AssignButNoCopy& assign_from) { return *this; }
};

// OK: before C++11, marking a constructor as private was an
// acceptable way to delete it. The constructor still might get used by
// accident within the scope of the class and its friends, but we tolerate that
// in order to avoid false positives on such code.
struct NotCopyable {
  NotCopyable() {}
private:
  NotCopyable(const NotCopyable& cannot_copy) {}
};

// OK: C++11 version of NotCopyable
struct NotCopyable11 {
  NotCopyable11(const NotCopyable11&) = delete;
};

// OK: both defined
struct HasBoth {
  HasBoth() {}
  HasBoth(const HasBoth& copy_from) {}
  HasBoth& operator=(const HasBoth& assign_from) { return *this; }
};

// OK: both generated
struct HasGenerated {
  HasBoth m_member;
};

// OK: this class gets a generated copy constructor but no copy
// assignment. We don't flag this as an error -- trying to copy-assign it will
// be a compilation error.
struct ConstMember {
  const int x;
};

// OK: this class declares a copy constructor but no copy
// assignment. But because it has a const member, it does not get a
// compiler-defined copy assignment operator, so there is no potential
// memory safety problem.
struct ConstMemberAndCopy {
  const int x;
  ConstMemberAndCopy(): x(4) {}
  ConstMemberAndCopy(const ConstMemberAndCopy& that): x(that.x) {}
};

// OK: Our class won't get a copy constructor.
struct NoAutoCopy {
  NotCopyable x; // has no copy constructor but has copy assignment
  NoAutoCopy& operator=(const NoAutoCopy& that) { x = that.x; return *this; }
};

// OK: When viewed in isolation, this class seems to use the pre-C++11 idiom of
// suppressing an auto-generated member by making it inaccessible.
struct CopyableByFriend {
  friend struct MyClassFriend;
private:
  CopyableByFriend(CopyableByFriend &) {} // OK: private
};

// OK: No auto-generated copy constructor
struct NotFriend {
  CopyableByFriend x;
  NotFriend& operator=(const NotFriend& that) { return *this; }
};

// NOT OK: Gets an auto-generated copy constructor because the class is a
// friend of CopyableByFriend.
struct MyClassFriend {
  CopyableByFriend x;
  MyClassFriend& operator=(const MyClassFriend& that) { return *this; }
};

// OK or NOT OK? An explicit default and an explicit implementation.
struct UsesDefault {
  UsesDefault(UsesDefault&) = default;
  UsesDefault& operator=(UsesDefault& ud) { return *this; }
};

// OK: copy constructor is user-defined, and there is no copy assignment.
struct DeletedAssign {
  DeletedAssign(DeletedAssign&) {}
  DeletedAssign& operator=(DeletedAssign& ud) = delete;
};

// OK: volatile instances can only be copied but not assigned, and that is
// not a correctness problem.
struct ProtectedVolatile {
protected:
  ProtectedVolatile(const volatile ProtectedVolatile& that) {}
public:
  ProtectedVolatile() {}
  ProtectedVolatile(const ProtectedVolatile& that) {}
  ProtectedVolatile& operator=(const ProtectedVolatile& that) {
    return *this;
  }
};

// OK: because `pv` is volatile, the compiler will try to generate a call to
// the protected copy constructor of ProtectedVolatile that takes a volatile
// argument. When access to this constructor fails, this class does not get an
// auto-generated copy constructor at all.
struct HasVPV {
  volatile ProtectedVolatile vpv;
  HasVPV& operator=(const HasVPV& that) {
    return *this;
  }
};

// FALSE NEGATIVE: the relevant copy constructor of ProtectedVolatile is
// accessible, so our class will get a generated copy constructor. Our query
// thinks the copy constructor is inaccessible because it picks up the other
// copy constructor. To fix this, our library should be changed to distinguish
// between copy constructors and resolve overloading properly instead of
// assuming that there is at most one.
struct HasPV {
  ProtectedVolatile pv;
  HasPV& operator=(const HasPV& that) {
    return *this;
  }
};

// OK: has explicit copy constructor and copy assignment operator.
struct ProtectedAssign {
  ProtectedAssign() {}
  ProtectedAssign(const ProtectedAssign& that) {}
protected:
  ProtectedAssign& operator=(const ProtectedAssign& that) { return *this; }
};

// NOT OK: this class gets a copy assignment operator because it can access the
// (protected) copy assignment operator of its base class.
struct IsAProtectedAssign: public ProtectedAssign {
  IsAProtectedAssign(const IsAProtectedAssign& that) {}
};

// OK: this class gets no copy assignment operator. It cannot access the
// (protected) copy assignment operator of its field even though it can access
// the same operator on its base class. For protected members, access is
// special when going through objects with the class of `this`.
struct HasAndIsAProtectedAssign: public ProtectedAssign {
  ProtectedAssign fieldB;
  HasAndIsAProtectedAssign(const HasAndIsAProtectedAssign& that) {}
};

// OK: has explicit copy constructor and copy assignment operator.
struct ProtectedCC {
  ProtectedCC() {}
  ProtectedCC& operator=(const ProtectedCC& that) { return *this; }
protected:
  ProtectedCC(const ProtectedCC& that) {}
};

// NOT OK: this class gets a copy constructor because it can access the
// (protected) copy constructor of its base class.
struct IsAProtectedCC: public ProtectedCC {
  IsAProtectedCC& operator=(const IsAProtectedCC& that) { return *this; }
};

// OK: this class gets no copy constructor. It cannot access the (protected)
// copy constructor of its field even though it can access the same operator on
// its base class. For protected members, access is special when going through
// objects with the class of `this`.
struct HasAndIsAProtectedCC: public ProtectedCC {
  ProtectedCC fieldB;
  HasAndIsAProtectedCC& operator=(const HasAndIsAProtectedCC& that) {
    return *this;
  }
};

// OK: defines both
struct DerivesVirtual: virtual public NotCopyable {
  DerivesVirtual(const DerivesVirtual& that) {}
  DerivesVirtual& operator=(const DerivesVirtual& that) { return *this; }
};

// OK: overrides only assignment but gets no auto-generated copy constructor
// because a virtual non-direct base class is not copyable.
struct DerivesDerivesVirtual: public DerivesVirtual {
  DerivesDerivesVirtual& operator=(const DerivesDerivesVirtual& that) {
    return *this;
  }
};

// OK: templates and their instantiations are ignored, but this class would
// be correct anyway.
template<class T>
struct HasBoth_template {
  T t_;
  HasBoth_template() {}
  HasBoth_template(const HasBoth_template<T>& copy_from)
    : t_(copy_from.t_)
  {}
  HasBoth_template& operator=(const HasBoth_template<T>& assign_from) {
    t_ = assign_from.t_;
    return *this;
  }
};

void use_copy_ctor(HasBoth_template<int> obj) {
  HasBoth_template<int> copy = obj;
}

// NOT OK (FALSE NEGATIVE): because this template is never instantiated, it
// does not appear in the database and is not caught by the analysis.
template<class T>
struct CopyButNoAssign_template {
  CopyButNoAssign_template() : n() {}
  CopyButNoAssign_template(const CopyButNoAssign_template& copy_from) : n(copy_from.n) {}
  T n;
};





// OK: copy assignment operator is uncallable because (a) it's private and (b)
// it has only a declaration but no definition, so the program would fail to
// link.
class UncallableCopyAssignment {
 public:
  UncallableCopyAssignment(const UncallableCopyAssignment& other) { }
  UncallableCopyAssignment() { }
 private:
  void operator=(UncallableCopyAssignment const &);
};

// OK: both members are "default"
struct BothDefault {
  BothDefault(BothDefault&) = default;
  BothDefault& operator=(BothDefault& bd) = default;
};



// OK: template class _with_ initializer on extra argument of copy constructor.
// We do not extract initializers of template functions or of functions in
// template classes, so our definition of a copy constructor is conservative
// and assumes they are present, which is correct in this case (`x` has `= 0`).
template<typename T>
class TemplateWithInit {
public:
  TemplateWithInit() {}

  TemplateWithInit(const TemplateWithInit& rhs, int x = 0) {
    *this = rhs;
  }

  TemplateWithInit& operator=(const TemplateWithInit& rhs) {
    return *this;
  }
};

void useGenericPointerAssign(TemplateWithInit<char> twi) {
  TemplateWithInit<char> twi2;
  twi2 = twi;
}

// NOT OK (FALSE NEGATIVE): template class _without_ initializer on extra
// argument of copy constructor. Like `TemplateWithInit` above but without `= 0`
// on `x`.
template<typename T>
class TemplateWithExtraArg {
public:
  TemplateWithExtraArg() {}

  TemplateWithExtraArg(const TemplateWithExtraArg& rhs, int x) {
    *this = rhs;
  }

  TemplateWithExtraArg& operator=(const TemplateWithExtraArg& rhs) {
    return *this;
  }
};

void useTemplateWithExtraArgAssign(TemplateWithExtraArg<char> twaa) {
  TemplateWithExtraArg<char> twaa2;
  twaa2 = twaa;
}



// OK: no user-defined copy constructor or assignment.
struct R1_A {
    R1_A() { }
    // Note: user-declared move constructor means copy constructor and
    //       assignment are both implicitly deleted.
    R1_A(R1_A&& a) { }
};

// OK: copy assignment implicitly deleted due to R1_A field.
class R1_B {
    public:
    R1_B(const R1_B& b) {}
    R1_A t;
};

// NOT OK: copy constructor user-defined and public, but copy assignment
//         is generated by the compiler and callable outside the class.
class R1_C {
    public:
    R1_C(const R1_C& c) {}
};
