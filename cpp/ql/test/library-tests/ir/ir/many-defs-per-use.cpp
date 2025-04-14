struct String {
    String();
    String(const String&);
    String(String&&);
    String(const char*);
    ~String();

    String& operator=(const String&);
    String& operator=(String&&);

    const char* c_str() const;
    char pop_back();
private:
    const char* p;
};

#define CONCAT(a, b) CONCAT_INNER(a, b)
#define CONCAT_INNER(a, b) a ## b

#define READ do { String CONCAT(x, __COUNTER__); } while(0)

#define READ2 READ; READ
#define READ4 READ2; READ2
#define READ8 READ4; READ4
#define READ16 READ8; READ8
#define READ32 READ16; READ16
#define READ64 READ32; READ32
#define READ128 READ64; READ64
#define READ256 READ128; READ128
#define READ512 READ256; READ256
#define READ1024 READ512; READ512
#define READ1025 READ1024; READ

void many_defs_per_use() {
    READ1025;
}

// semmle-extractor-options: -std=c++20 --clang
