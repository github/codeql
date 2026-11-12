// Regression cases for github/codeql#7035.
template<class T>
T& assignFirst(T& destination, const T& source) {
  destination.value = source.value;
  return destination;
}

struct GoodTemplate {
  int value;
  GoodTemplate& operator=(const GoodTemplate& other) { // GOOD
    return assignFirst(*this, other);
  }
  GoodTemplate& operator=(GoodTemplate&& other) { // GOOD
    return assignFirst(*this, other);
  }
};

struct GoodFree;
GoodFree& assignFree(GoodFree& destination, const GoodFree& source);
struct GoodFree {
  int value;
  GoodFree& operator=(const GoodFree& other) { // GOOD
    return assignFree(*this, other);
  }
};
GoodFree& assignFree(GoodFree& destination, const GoodFree& source) {
  destination.value = source.value;
  return destination;
}

struct StaticHelper {
  template<class T>
  static T& assign(const T& source, T& destination) {
    destination.value = source.value;
    return destination;
  }
};
struct GoodSecondArgument {
  int value;
  GoodSecondArgument& operator=(const GoodSecondArgument& other) { // GOOD
    return StaticHelper::assign(other, *this);
  }
};

template<class T>
T& branching(T& destination, bool flag) {
  if (flag) return destination;
  destination.value = 0;
  return destination;
}
struct GoodBranches {
  int value;
  GoodBranches& operator=(int other) { // GOOD
    return branching(*this, other != 0);
  }
};

template<class T>
T& unreachableOther(T& destination, T& other) {
  if (1) return destination;
  else return other;
}
struct GoodUnreachable {
  int value;
  GoodUnreachable& operator=(GoodUnreachable& other) { // GOOD
    return unreachableOther(*this, other);
  }
};

struct GoodTypedef {
  typedef GoodTypedef& Reference;
  static Reference identity(Reference destination) { return (destination); }
  GoodTypedef& operator=(int) { // GOOD
    return identity(*this);
  }
};

template<class T>
T& maybeThrow(T& destination, bool fail) {
  if (fail) throw 1;
  return destination;
}
struct GoodThrows {
  GoodThrows& operator=(int other) { // GOOD
    return maybeThrow(*this, other != 0);
  }
};

template<class T>
T& returnOther(T& destination, T& other) { return other; }
struct BadOther {
  BadOther& operator=(BadOther& other) { // $ Alert
    return returnOther(*this, other);
  }
};

template<class T>
T& mixedReturns(T& destination, T& other, bool flag) {
  if (flag) return destination;
  return other;
}
struct BadBranches {
  BadBranches& operator=(BadBranches& other) { // $ Alert
    return mixedReturns(*this, other, false);
  }
};

template<class T>
T& conditionalReturn(T& destination, T& other, bool flag) {
  return flag ? destination : other;
}
struct BadConditional {
  BadConditional& operator=(BadConditional& other) { // $ Alert
    return conditionalReturn(*this, other, false);
  }
};

template<class T>
T& byValue(T destination) { return destination; }
struct BadValueParameter {
  BadValueParameter& operator=(int) { // $ Alert
    return byValue(*this);
  }
};

template<class T>
T byValueResult(T& destination) { return destination; }
struct BadValueResult {
  BadValueResult operator=(int) { // $ Alert
    return byValueResult(*this);
  }
};

struct BadMissingBody;
BadMissingBody& unknownIdentity(BadMissingBody& destination);
struct BadMissingBody {
  BadMissingBody& operator=(int) { // $ Alert
    return unknownIdentity(*this);
  }
};

struct BadVirtual;
struct VirtualHelper {
  virtual BadVirtual& select(BadVirtual& destination) { return destination; }
};
struct BadVirtual {
  BadVirtual& operator=(VirtualHelper& helper) { // $ Alert
    return helper.select(*this);
  }
};
struct OtherVirtualHelper : VirtualHelper {
  BadVirtual other;
  BadVirtual& select(BadVirtual&) override { return other; }
};

struct BadConversion;
struct Proxy {
  operator BadConversion&();
};
BadConversion& convertingHelper(Proxy& proxy) { return proxy; }
struct BadConversion {
  Proxy proxy;
  operator Proxy&() { return proxy; }
  BadConversion& operator=(int) { // $ Alert
    return convertingHelper(*this);
  }
};

void instantiateHelpers() {
  GoodTemplate first, second;
  first = second;
  first = static_cast<GoodTemplate&&>(second);
  GoodSecondArgument a, b;
  a = b;
  GoodBranches branches;
  branches = 1;
  GoodUnreachable x, y;
  x = y;
  GoodThrows throwing;
  throwing = 0;
  BadOther o, p;
  o = p;
  BadBranches c, d;
  c = d;
  BadConditional e, f;
  e = f;
  BadValueParameter value;
  value = 0;
  BadValueResult result;
  result = 0;
}
