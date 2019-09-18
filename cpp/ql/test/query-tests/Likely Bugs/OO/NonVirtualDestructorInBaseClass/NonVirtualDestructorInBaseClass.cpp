struct HasDtor
{
    ~HasDtor();
};

struct Base_NonVirtual_NoDtor
{
    void NonVirtualFunction();
};

struct Base_NonVirtual_VirtualDtor
{
    virtual ~Base_NonVirtual_VirtualDtor();
    void NonVirtualFunction();
};

struct Base_NonVirtual_NonVirtualDtor
{
    ~Base_NonVirtual_NonVirtualDtor();
    void NonVirtualFunction();
};

struct Base_NonVirtual_ImplicitDtor
{
    HasDtor m_hasDtor;
    void NonVirtualFunction();
};

struct Derived_NonVirtual_NoDtor : public Base_NonVirtual_NoDtor
{
};

struct Derived_NonVirtual_VirtualDtor : public Base_NonVirtual_VirtualDtor
{
};

struct Derived_NonVirtual_NonVirtualDtor : public Base_NonVirtual_NonVirtualDtor
{
};

struct Derived_NonVirtual_ImplicitDtor : public Base_NonVirtual_ImplicitDtor
{
};

struct Base_Virtual_NoDtor
{
    virtual void VirtualFunction();
};

struct Base_Virtual_VirtualDtor
{
    virtual ~Base_Virtual_VirtualDtor();
    virtual void VirtualFunction();
};

struct Base_Virtual_NonVirtualDtor
{
    ~Base_Virtual_NonVirtualDtor();
    virtual void VirtualFunction();
};

struct Base_Virtual_ImplicitDtor
{
    HasDtor m_hasDtor;
    virtual void VirtualFunction();
};

struct Base_Virtual_NonVirtualDtorWithDefinition
{
    ~Base_Virtual_NonVirtualDtorWithDefinition();
    virtual void VirtualFunction();
};

Base_Virtual_NonVirtualDtorWithDefinition::~Base_Virtual_NonVirtualDtorWithDefinition()
{
}

struct Base_Virtual_NonVirtualDtorWithInlineDefinition
{
    ~Base_Virtual_NonVirtualDtorWithInlineDefinition()
    {
    }
    virtual void VirtualFunction();
};

struct Base_Virtual_ProtectedNonVirtualDtor
{
protected:
    ~Base_Virtual_ProtectedNonVirtualDtor();

public:
    virtual void VirtualFunction();
};

struct Derived_Virtual_NoDtor : public Base_Virtual_NoDtor
{
};

struct Derived_Virtual_VirtualDtor : public Base_Virtual_VirtualDtor
{
};

struct Derived_Virtual_NonVirtualDtor : public Base_Virtual_NonVirtualDtor
{
};

struct Derived_Virtual_ImplicitDtor : public Base_Virtual_ImplicitDtor
{
};

struct Derived_Virtual_NonVirtualDtorWithDefinition: public Base_Virtual_NonVirtualDtorWithDefinition
{
};

struct Derived_Virtual_NonVirtualDtorWithInlineDefinition: public Base_Virtual_NonVirtualDtorWithInlineDefinition
{
};

struct Derived_Virtual_ProtectedNonVirtualDtor : public Base_Virtual_ProtectedNonVirtualDtor
{
};
