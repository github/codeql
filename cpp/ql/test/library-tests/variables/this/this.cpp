class TestImplicitThis
{
public:
    int field;

    int get() const {
        return field + this->field + get() + this->get();
    }
};
