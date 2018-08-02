
int variable;

void protoOnly(void);

void defOnly(void) { }

void protoAndDef(void);
void protoAndDef(void) { }

template<typename T>
void tmplProtoOnly(T t);

template<typename T>
void tmplDefOnly(T t) {}

template<typename T>
void tmplProtoAndDef(T t);
template<typename T>
void tmplProtoAndDef(T t) {}

class Cl {
    int clVar;

    void clProtoOnly(void);

    void clDefOnly(void) { }

    void clProtoAndDef(void);

    template<typename T>
    void clTmplProtoOnly(T t);

    template<typename T>
    void clTmplDefOnly(T t) {}

    template<typename T>
    void clTmplProtoAndDef(T t);
};

void Cl::clProtoAndDef(void) { }

template<typename T>
void Cl::clTmplProtoAndDef(T t) {}

class classProtoOnly;

class classProtoAndDef;
class classProtoAndDef { };

template<typename T>
class tmplClassProtoOnly;

template<typename T>
class tmplClassProtoAndDef;
template<typename T>
class tmplClassProtoAndDef { };

template<typename T>
void tmplInstantiatedFunction(T t);
template<typename T>
void tmplInstantiatedFunction(T t) {}

template<typename T>
class tmplInstantiatedClass;
template<typename T>
class tmplInstantiatedClass {
    T t;
};

void f(void) {
    tmplInstantiatedClass<int> tici;
    tmplInstantiatedClass<double> ticd;
    int i;
    double d;
    tmplInstantiatedFunction(i);
    tmplInstantiatedFunction(d);
}

