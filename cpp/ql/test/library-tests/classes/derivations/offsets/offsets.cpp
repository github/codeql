struct Base {
    int b1;
    float b1f;
};

struct SingleInheritance : Base {
    int si1;
    float si1f;
};

struct Base2 {
    int b2;
    float b2f;
};

struct MultipleInheritance : Base, Base2 {
    int mi1;
    float mi1f;
};

struct DeepInheritance : MultipleInheritance, SingleInheritance {
    int di1;
    float di1f;
};

struct VirtualInheritance1 : virtual Base {
    int vi1;
    float vi1f;
};

struct VirtualInheritance2 : VirtualInheritance1, virtual Base, virtual Base2 {
    int vi2;
    float vi2f;
};

struct EffectivelyVirtual : virtual SingleInheritance, MultipleInheritance {
    int ev1;
    float ev1f;
};

struct PolymorphicBase {
    virtual ~PolymorphicBase();
    int pb1;
    float pb1f;
};

struct InheritsVTable : PolymorphicBase {
    int iv1;
    float iv1f;
};

struct IntroducesVTable : Base {
    virtual ~IntroducesVTable();
    int iv2;
    float iv2f;
};

struct Left : virtual Base {
    int l1;
    float l1f;
};

struct Right : virtual Base {
    int r1;
    float r1f;
};

struct Bottom : Left, Right {
    int b1;
    float b1f;
};

struct DeepSingleInheritance : SingleInheritance {
    int dsi1;
    float dsi1f;
};

struct Incomplete;
Incomplete* p;

template<typename T>
struct TemplateClass : Base
{
};
