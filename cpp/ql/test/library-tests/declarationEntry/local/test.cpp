// test.cpp

struct myStruct1;
typedef myStruct1 myTypedef1;

typedef struct myStruct2 myTypedef2;

struct myStruct3;
void myFunc3(myStruct3 *param);

void myFunc4(struct myStruct4 *param);

void myFunc5(struct myStruct5 *param) {
}

struct myStruct6;
void myFunc6(struct myStruct6 *param);

struct myStruct7 *myFunc7();

void myFunc8a(struct myStruct8 *param);
void myFunc8b(struct myStruct8 *param);

void myFunc9() {
	struct myStruct9;
}

class myClass1 {
public:
	struct myStruct10;
};

template <class T> class myTemplateClass1;

class myClass2 {
public:
	template <class T> class myTemplateClass2;
};
