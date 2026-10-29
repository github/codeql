
typedef struct {
    int v[1024];
} t;

int f1(t *p);
int f2(t *p);
int f3(const t *p);
int f4(const t *p);

int f1(t *p) {
    int w[2048];
    return p->v[1];
}

int f2(t *p) {
    int w[2048];
    return p->v[1];
}
int f3(const t *p) {
    int w[2048];
    return p->v[1];
}

int f4(const t *p) {
    int w[2048];
    return p->v[1];
}

