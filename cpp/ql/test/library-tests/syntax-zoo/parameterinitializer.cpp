void printf(char *format, ...);

static int g(void) {
    return 5;
}

static void f(int i = g()) {
    printf("Got %d\n", i);
}

class c {
public:
	c(int j = g()) {};
	
	void method(int k = g()) {};
};

static int h(void) {
    f(3);
    f();
    f(4);
    f();
    
    {
		c my_c;

		my_c.method();
    }

    return 0;
}
