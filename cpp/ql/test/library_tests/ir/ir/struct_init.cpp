int handler1(void *p);
int handler2(void *p);

struct Info {
    const char *name;
    int (*handler)(void *);
};

static Info infos_in_file[] = {
    { "1", handler1 },
    { "3", &handler2 },
};

Info *global_pointer;

void let_info_escape(Info *info) {
    global_pointer = info;
}

void declare_static_infos() {
    static Info static_infos[] = {
        { "1", handler1 },
        { "2", &handler2 },
    };
    let_info_escape(static_infos);
}

void declare_local_infos() {
    Info local_infos[] = {
        { "1", handler1 },
        { "2", &handler2 },
    };
    let_info_escape(local_infos);
}

void declare_static_runtime_infos(const char *name1) {
    static Info static_infos[] = {
        { name1, handler1 },
        { "2", &handler2 },
    };
    let_info_escape(static_infos);
}
