template <class T>
struct NEQ_helper
{
     friend bool operator!=(const T& x, const T& y) { return !static_cast<bool>(x == y); }
};
