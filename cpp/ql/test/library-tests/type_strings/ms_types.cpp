int        ms_int;
int  __w64 ms_w64_int;
int* __w64 ms_w64_int_ptr;
int*       ms_int_ptr;

int (          *ms_fptr1)(void);
int (__cdecl   *ms_fptr2)(void);
int (__stdcall *ms_fptr3)(void);
// semmle-extractor-options: --microsoft
