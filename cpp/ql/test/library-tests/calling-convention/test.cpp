// semmle-extractor-options: --microsoft

struct call_conventions {
    void __thiscall thiscall_method() {}
};

void __cdecl func_cdecl() {}

void __stdcall func_stdcall() {}

void __fastcall func_fastcall() {}

void __vectorcall  func_vectorcall() {}

int __cdecl func_overload() {}
int __stdcall func_overload(int x) {}
