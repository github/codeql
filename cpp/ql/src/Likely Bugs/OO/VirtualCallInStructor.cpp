class Base {
protected:
    Resource* resource;
public:
    virtual void init() {
        resource = createResource();
    }
    virtual void release() {
        freeResource(resource);
    }
};

class Derived: public Base {
    virtual void init() {
        resource = createResourceV2();
    }
    virtual void release() {
        freeResourceV2(resource);
    }
};

Base::Base() {
    this->init();
}
Base::~Base() {
    this->release();
}

int f() {
    // this will call Base::Base() and then Derived::Derived(), but this->init()
    // inBase::Base() will resolve to Base::init(), not Derived::init()
    // The reason for this is that when Base::Base is called, the object being
    // created is still of type Base (including the vtable)
    Derived* d = new Derived();
}
