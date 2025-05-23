void sink(char);
void sink(char*);

int WinMain(void *hInstance, void *hPrevInstance, char *pCmdLine, int nCmdShow) { // $ ast-def=hInstance ast-def=hPrevInstance ast-def=pCmdLine ir-def=*hInstance ir-def=*hPrevInstance ir-def=*pCmdLine 
  sink(pCmdLine);
  sink(*pCmdLine); // $ MISSING: ir

  return 0;
}
