
void f1(void) throw (int);
void f2(void) throw ();
void f3(void);
void f4(void) { return; }
void f5(void) { throw 3; }
void g(void);
void h(void);
void i(void);
void j(void);
void k(void);
void l(void);
void m(void);
void n(void);


void fun(void) {
    try {
        try {
            f1();
            f2();
            f3();
            f4();
            f5();
            throw 5;
            g();
        }
        catch (int e) {
            h();
        }
    }
    catch (int e) {
        i();
    }
    catch (int e) {
        j();
    }
    k();

    try {
      throw 7;
    } catch (int e) {
      l();
    } catch (...) {
      m();
    }
    n();

    return;
}
