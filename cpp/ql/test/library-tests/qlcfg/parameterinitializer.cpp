void printf(char *format, ...);

int g(void) {
    return 5;
}

void f(int i = g()) {
    printf("Got %d\n", i);
}

class c {
public:
	c(int j = g()) {};
	
	void method(int k = g()) {};
};

int main(void) {
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
