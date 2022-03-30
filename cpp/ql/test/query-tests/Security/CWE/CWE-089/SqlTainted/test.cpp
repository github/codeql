int sprintf(char* str, const char* format, ...);

namespace std
{
	template<class charT> struct char_traits;

	template <class T> class allocator {
	public:
		allocator() throw();
	};
	
	template<class charT, class traits = char_traits<charT>, class Allocator = allocator<charT> >
	class basic_string {
	public:
		explicit basic_string(const Allocator& a = Allocator());
		basic_string(const charT* s, const Allocator& a = Allocator());

		const charT* c_str() const;
	};

	typedef basic_string<char> string;
}

namespace pqxx {
    struct connection {};

    struct row {};
    struct result {};

    struct work {
      work(connection&);

      row exec1(const char*);
      result exec(const std::string&);
      std::string quote(const char*);
    };
}

int main(int argc, char** argv) {
    pqxx::connection c;
    pqxx::work w(c);
    
    pqxx::row r = w.exec1(argv[1]); // BAD
    
    pqxx::result r2 = w.exec(w.quote(argv[1])); // GOOD

    return 0;
}