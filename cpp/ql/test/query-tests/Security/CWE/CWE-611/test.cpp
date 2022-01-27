class AbstractDOMParser {
    public:
    AbstractDOMParser();
    void setDisableDefaultEntityResolution(bool);
    void setCreateEntityReferenceNodes(bool);
    void setSecurityManager();
    void parse();
}

class XercesDOMParser: public AbstractDOMParser {
    public:
    XercesDOMParser();
}

class LSParser: public AbstractDOMParser {

}

LSParser createLSParser();

void test1() {
    XercesDOMParser p = new XercesDOMParser();
    p.parse() // BAD
}

void test2() {
    XercesDOMParser p = new XercesDOMParser();
    p.setDisableDefaultEntityResolution(true);
    p.parse() // GOOD
}

void test3() {
    LSParser p = createLSParser();
    p.parse() // BAD
}

void test2() {
    LSParser p = createLSParser();
    p.setDisableDefaultEntityResolution(true);
    p.parse() // GOOD
}
