
int a[100];
typedef int my_array[200];

void g1(int b[300]);
void g1(int b[300]) {
    int c[400];

    typedef int my_array_2[500];
    my_array d;
    my_array_2 e;

    class f
    {
    public:
        void g2()
        {
            int g[600];
        }
		
        int h[700];
    };

    int i = sizeof(int[800]);
    auto j = new int[900];
    int *k = new int[1000];
}
