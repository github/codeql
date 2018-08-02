extern int externInt;

class std_istream_mockup {
public:
    std_istream_mockup &operator>>(short int &i) {
        i = externInt;
        return *this;
    }
};


template<class IStream>
class basic_text_iprimitive
{
    IStream &is;
public:

    basic_text_iprimitive(IStream &isParam)
        : is(isParam) {}

    template<class T>
    void load(T & t)
    {
        is >> t;
    }

    void load(char & t)
    {
        short int i;
        load(i);
        t = i;
    }
};

template class basic_text_iprimitive<std_istream_mockup>;
