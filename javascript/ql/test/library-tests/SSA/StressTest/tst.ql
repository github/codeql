import javascript

select count(SsaVariable d,
    // compute SSA def-use
    VarUse u | u = d.getAUse()),
  // maximum length of basic block
  max(int n | n = any(BasicBlock bb).length()),
  // maximum number of basic blocks per container
  max(int n | exists(StmtContainer sc | n = count(BasicBlock bb | bb.getContainer() = sc)))
