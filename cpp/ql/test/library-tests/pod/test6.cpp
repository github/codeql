
class Test6_1 {
public:
	int x, y;
	void fun();
};

class Test6_2 {
private:
	int x, y;
	void fun();
};

class Test6_3 {
public:
	int x;
private:
	int y; // different access control -> not standard layout
};

class Test6_4 {
public:
	virtual void fun(); // virtual function -> not standard layout, not trivial
};

// ---

class Test6_20 : public Test6_1 {
	static int z;
};

class Test6_21 : public Test6_1 {
	int z; // non-static variable in more than one part of in heritance graph -> not standard layout
};

class Test6_22 : public Test6_3 { // non-standard layout base class -> not standard layout
};

class Test6_23 : public virtual Test6_1 { // virtual inheritance -> not standard layout, not trivial
};

class Test6_24 {
public:
	Test6_3 obj; // non-standard layout, non-static variable -> not standard layout
};

class Test6_25 {
public:
	static Test6_3 obj;
};

class Test6_26 {
public:
	Test6_3 &obj_ref; // non-standard layout, non-static variable -> not standard layout
};

class Test6_27 {
public:
	Test6_3 obj_arr[10]; // non-standard layout, non-static variable -> not standard layout
};

// ---

class Test6_30 {
};

class Test6_31 : public Test6_30 {
public:
	Test6_30 obj; // base class has same type as first non-static variable -> not standard layout
};

class Test6_32 : public Test6_30 {
public:
	int x;
	Test6_30 obj;
	Test6_30 &obj_ref;
	Test6_30 obj_arr[10];
};

// ---

class Test6_40 {
public:
	Test6_40() {}; // user provided constructor -> not trivial
};

class Test6_41 : public Test6_40 { // base class non-trivial -> not trivial
};

class Test6_42 {
public:
	Test6_40 obj; // non-trivial variable -> not trivial
};
