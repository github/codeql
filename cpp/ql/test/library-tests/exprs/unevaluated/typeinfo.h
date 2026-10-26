namespace std {
class exception {
};

class type_info
{
public:
    virtual ~type_info();
    bool operator==(const type_info& rhs) const noexcept;
    bool operator!=(const type_info& rhs) const noexcept;
    bool before(const type_info& rhs) const noexcept;
    int hash_code() const noexcept;
    const char* name() const noexcept;
    type_info(const type_info& rhs) = delete;
    type_info& operator=(const type_info& rhs) = delete;
};
class bad_cast
    : public exception
{
public:
    bad_cast() noexcept;
    bad_cast(const bad_cast&) noexcept;
    bad_cast& operator=(const bad_cast&) noexcept;
    virtual const char* what() const noexcept;
};
class bad_typeid
    : public exception
{
public:
    bad_typeid() noexcept;
    bad_typeid(const bad_typeid&) noexcept;
    bad_typeid& operator=(const bad_typeid&) noexcept;
    virtual const char* what() const noexcept;
};
}
