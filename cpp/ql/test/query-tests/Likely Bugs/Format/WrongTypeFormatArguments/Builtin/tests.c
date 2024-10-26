void f() {
    char buf[35];
    __builtin___sprintf_chk(buf, 0, __builtin_object_size(buf, 1), "%s", 1);
    __builtin___sprintf_chk(buf, 0, __builtin_object_size(buf, 1), "%d", 1);
}
