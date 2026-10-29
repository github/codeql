#define Wrap1(s) s
#define Wrap2(s) Wrap1(s)

#define Widen1(s) L ## s
#define Widen2(s) Widen1(s)

void argused(...);

void narrow() {
  const char* nzero = "Narrow \xa2 Zero";
  const char* none = Wrap1("Narrow \xa2 One");
  const char* ntwo = Wrap2("Narrow \xa2 Two");
  char nthree = 'H';
  char nfour = '\x9f';
  char newline = '\n';
  char exotic = '\
e';
  
  argused(nzero, none, ntwo, nthree, nfour, newline, exotic);
}

void wide() {
  const wchar_t* wzero = L"Wide \x20ac Zero";
  const wchar_t* wone = Widen1("Wide \x20ac One");
  const wchar_t* wtwo = Widen2("Wide \x20ac Two");
  wchar_t wthree = L'H';
  wchar_t wfour = L'\x9f';
  wchar_t wewline = L'\n';
  wchar_t wxotic = L'\
e';
  
  argused(wzero, wone, wtwo, wthree, wfour, wewline, wxotic);
}

#define ONE_HUNDRED 100

void integers() {
  int zero = 0;
  
  int dec = 100;
  int hex = 0x64;
  int oct = 0144;
  
  int computed = 40 + 60;
  int macroish = Wrap1(40) + Wrap1(60);
  int full_macro = ONE_HUNDRED;
  
  argused(zero, dec, hex, oct, computed, macroish, full_macro);
}

void aggregates() {
  float id[3][3] = {{1., 0., 0.}, {0., 1., 0.}, {0., 0., 1.}};
  struct {int x; int y;} x_axis = {1, 0};
  
  argused(id, x_axis);
}
// semmle-extractor-options: --edg --target --edg win64
