int h_var __attribute__((visibility("hidden")));
int p_var __attribute__((visibility("protected")));
int i_var __attribute__((visibility("internal")));
int d_var __attribute__((visibility("default")));

__attribute__((visibility("hidden")))    void h_rout();
__attribute__((visibility("protected"))) void p_rout();
__attribute__((visibility("internal")))  void i_rout();
__attribute__((visibility("default")))   void d_rout();

struct __attribute__((visibility("hidden")))    h_type {};
struct __attribute__((visibility("protected"))) p_type {};
struct __attribute__((visibility("internal")))  i_type {};
struct __attribute__((visibility("default")))   d_type {};
