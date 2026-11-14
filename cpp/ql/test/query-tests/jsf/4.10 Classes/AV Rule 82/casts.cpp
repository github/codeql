// Explicit conversions can select a different subobject of the same base type.
template<class Base> struct LeftBase : Base {};
template<class Base> struct RightBase : Base {};
template<class Base> struct TwoBases : LeftBase<Base>, RightBase<Base> {};

template<class T>
T& identity(T& destination) { return (destination); }

template<class T>
T& otherBase(T& destination) {
  return static_cast<T&>(static_cast<RightBase<T>&>(
      static_cast<TwoBases<T>&>(static_cast<LeftBase<T>&>(destination))));
}

template<class T>
T& otherBaseCStyle(T& destination) {
  return (T&)(RightBase<T>&)(TwoBases<T>&)(LeftBase<T>&)destination;
}

struct BadHelperReturnCast {
  BadHelperReturnCast& operator=(int) { // $ Alert
    return otherBase(*this);
  }
};

struct BadHelperReturnCStyleCast {
  BadHelperReturnCStyleCast& operator=(int) { // $ Alert
    return otherBaseCStyle(*this);
  }
};

struct BadHelperArgumentCast {
  BadHelperArgumentCast& operator=(int) { // $ Alert
    return identity(static_cast<BadHelperArgumentCast&>(static_cast<RightBase<BadHelperArgumentCast>&>(
        static_cast<TwoBases<BadHelperArgumentCast>&>(static_cast<LeftBase<BadHelperArgumentCast>&>(*this)))));
  }
};

struct BadHelperPointerCast {
  BadHelperPointerCast& operator=(int) { // $ Alert
    return identity(*static_cast<BadHelperPointerCast*>(static_cast<RightBase<BadHelperPointerCast>*>(
        static_cast<TwoBases<BadHelperPointerCast>*>(static_cast<LeftBase<BadHelperPointerCast>*>(this)))));
  }
};

struct BadHelperConditionalCast {
  BadHelperConditionalCast& operator=(bool flag) { // $ Alert
    return identity(flag ? *this : static_cast<BadHelperConditionalCast&>(static_cast<RightBase<BadHelperConditionalCast>&>(
        static_cast<TwoBases<BadHelperConditionalCast>&>(static_cast<LeftBase<BadHelperConditionalCast>&>(*this)))));
  }
};

struct BadHelperCommaCast {
  BadHelperCommaCast& operator=(int) { // $ Alert
    return identity((0, static_cast<BadHelperCommaCast&>(static_cast<RightBase<BadHelperCommaCast>&>(
        static_cast<TwoBases<BadHelperCommaCast>&>(static_cast<LeftBase<BadHelperCommaCast>&>(*this))))));
  }
};

struct BadHelperMemberReturnCast {
  BadHelperMemberReturnCast* otherPointer() {
    return static_cast<BadHelperMemberReturnCast*>(static_cast<RightBase<BadHelperMemberReturnCast>*>(
        static_cast<TwoBases<BadHelperMemberReturnCast>*>(static_cast<LeftBase<BadHelperMemberReturnCast>*>(this))));
  }
  BadHelperMemberReturnCast& operator=(int) { // $ Alert
    return identity(*this->otherPointer());
  }
};

struct BadHelperQualifierCast {
  BadHelperQualifierCast* selfPointer() { return this; }
  BadHelperQualifierCast& operator=(int) { // $ Alert
    return identity(*static_cast<BadHelperQualifierCast*>(static_cast<RightBase<BadHelperQualifierCast>*>(
        static_cast<TwoBases<BadHelperQualifierCast>*>(static_cast<LeftBase<BadHelperQualifierCast>*>(this))))->selfPointer());
  }
};

struct GoodHelperArgumentPaths {
  GoodHelperArgumentPaths* selfPointer() { return this; }

  GoodHelperArgumentPaths& operator=(int) { // GOOD: parentheses are not casts.
    return identity(((*this)));
  }
  GoodHelperArgumentPaths& operator=(bool flag) { // GOOD
    return identity(flag ? *this : *this);
  }
  GoodHelperArgumentPaths& operator=(char) { // GOOD
    return identity((0, *this));
  }
  GoodHelperArgumentPaths& operator=(long flag) { // GOOD: the condition does not supply the reference.
    return identity(static_cast<bool>(flag) ? *this : *this);
  }
  GoodHelperArgumentPaths& operator=(unsigned int value) { // GOOD: neither does the left comma operand.
    return identity((static_cast<void>(value), *this));
  }
  GoodHelperArgumentPaths& operator=(double) { // GOOD
    return identity(*this->selfPointer());
  }
};

struct BadHelperResultCast {
  BadHelperResultCast& operator=(int) { // $ Alert
    return static_cast<BadHelperResultCast&>(static_cast<RightBase<BadHelperResultCast>&>(
        static_cast<TwoBases<BadHelperResultCast>&>(static_cast<LeftBase<BadHelperResultCast>&>(identity(*this)))));
  }
};
