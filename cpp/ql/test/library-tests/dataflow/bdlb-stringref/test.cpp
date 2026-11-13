// Reduced declarations from bslstl_stringref.h and bdlb_stringrefutil.h.
namespace bsl {
template<bool, class T> struct enable_if {};
template<class T> struct enable_if<true, T> { typedef T type; };
template<class T> struct is_integral { enum { value = false }; };
template<> struct is_integral<int> { enum { value = true }; };
}
namespace BloombergLP {
namespace bslmf { struct Nil {}; }
namespace bslstl {
template<class C> class StringRefImp {
public:
  typedef unsigned long size_type;
  typedef const C *const_iterator;
  StringRefImp();
  StringRefImp(const C *);
  StringRefImp(const C *, size_type);
  // Integral overload: the upstream enable_if resolves to bslmf::Nil.
  template<class I> StringRefImp(const C *, I,
    typename bsl::enable_if<bsl::is_integral<I>::value, bslmf::Nil>::type = bslmf::Nil());
  StringRefImp(const_iterator, const_iterator);
  const C *data() const;
  const_iterator begin() const;
  const C& operator[](size_type) const;
  size_type length() const;
};
typedef StringRefImp<char> StringRef;
}
namespace bdlb {
struct StringRefUtil {
  typedef unsigned long size_type;
  static bslstl::StringRef trim(const bslstl::StringRef&);
  static bslstl::StringRef ltrim(const bslstl::StringRef&);
  static bslstl::StringRef rtrim(const bslstl::StringRef&);
  static bslstl::StringRef substr(const bslstl::StringRef&, size_type = 0, size_type = -1);
  static bslstl::StringRef strstr(const bslstl::StringRef&, const bslstl::StringRef&);
  static bslstl::StringRef strrstr(const bslstl::StringRef&, const bslstl::StringRef&);
  static bslstl::StringRef strstrCaseless(const bslstl::StringRef&, const bslstl::StringRef&);
  static bslstl::StringRef strrstrCaseless(const bslstl::StringRef&, const bslstl::StringRef&);
};
}
}
using BloombergLP::bslstl::StringRef;
using BloombergLP::bdlb::StringRefUtil;
int source();
void sink(int);

void views() {
  char buffer[] = {static_cast<char>(source()), 0};
  StringRef view(buffer);
  sink(view.data()[0]); // $ ir
  sink(view[0]); // $ ir
  sink(*view.begin()); // $ ir
  StringRef copy(view);
  sink(copy[0]); // $ ir
  StringRef sized(buffer, static_cast<unsigned long>(1));
  sink(sized[0]); // $ ir
  StringRef range(buffer, buffer + 1);
  sink(range[0]); // $ ir
  StringRef integral(buffer, 1);
  sink(integral[0]); // $ ir
  sink(view.length());
  sink(StringRefUtil::trim(view)[0]); // $ ir
  sink(StringRefUtil::ltrim(view)[0]); // $ ir
  sink(StringRefUtil::rtrim(view)[0]); // $ ir
  sink(StringRefUtil::substr(view)[0]); // $ ir
  sink(StringRefUtil::strstr(view, "x")[0]); // $ ir
  sink(StringRefUtil::strrstr(view, "x")[0]); // $ ir
  sink(StringRefUtil::strstrCaseless(view, "x")[0]); // $ ir
  sink(StringRefUtil::strrstrCaseless(view, "x")[0]); // $ ir
}

void metadataAndPatterns() {
  unsigned long length = source();
  StringRef clean("clean", length);
  sink(clean[0]);
  sink(StringRefUtil::substr(clean, length, length)[0]);
  char buffer[] = {static_cast<char>(source()), 0};
  StringRef pattern(buffer);
  sink(StringRefUtil::strstr(clean, pattern)[0]);
  sink(StringRefUtil::strrstr(clean, pattern)[0]);
  sink(StringRefUtil::strstrCaseless(clean, pattern)[0]);
  sink(StringRefUtil::strrstrCaseless(clean, pattern)[0]);
  sink(StringRefUtil::strstr(clean, "missing").length());
}

void wide() {
  wchar_t buffer[] = {static_cast<wchar_t>(source()), 0};
  BloombergLP::bslstl::StringRefImp<wchar_t> view(buffer);
  sink(view[0]); // $ ir
}
