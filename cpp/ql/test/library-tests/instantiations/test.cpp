
class A { public: ~A() { } };

class X { public: virtual bool vf(void) = 0; };

/*
Y has a generated destructor, but it is only reachable via an
instantiated class. Therefore if indexing of class instantiations
is deferred then we do not index the destructor.

If *_TEMPLATE_INSTANTIATIONS_IN_SOURCE_SEQUENCE_LISTS are enabled
then it also becomes reachable via the source sequence lists.
*/
class Y : public X { public: bool vf(void) override; A a; };

class B { public: virtual void vfun() = 0; };

template<typename T>
class C : public B {
    public:
    virtual void vfun()  {
        T* x;
        x->~T();
    }
};

void f(void) { new C<Y>(); }

