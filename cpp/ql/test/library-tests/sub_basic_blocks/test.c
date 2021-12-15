int cut(int);

int f(int n) {
    int i = 0;
    while (++i < cut(n) + 1) {
    	int j = i + 1;
    	cut(0);
    	int k = j + cut(j);
    	cut(k);
    }
    return 1 + cut(i);
}
