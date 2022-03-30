
enum class EC : int {
    V
};

template<EC X>
struct IsX {
    static const bool Value = false;
};

template<EC X, bool B = IsX<X>::Value>
struct DX {
    typedef int Type;
};

template<EC X>
struct IX {
    static const EC Value = EC::V;
};

template<EC Y>
void run() {
    const EC y = IX<Y>::Value;
    typedef typename DX<y>::Type T;
}

