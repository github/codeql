__declspec(noreturn) extern void fatal();
__declspec(dllimport) int imported();
__declspec(dllexport) int exported() { return 4; }
__declspec(deprecated("Use fatal() instead")) extern void exit();
__declspec(naked) int no_clothes() {}
__declspec(restrict) float* ma(int size);
__declspec(noalias) void multiply(float* a, float* b, float* c);
class X {
   __declspec(noinline) int mbrfunc() {
      return 0; 
   }   // will not inline
};
static __declspec(nothrow, safebuffers) int noCheckBuffers();
// semmle-extractor-options: --microsoft
