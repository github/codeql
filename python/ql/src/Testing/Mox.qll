import python

/** Whether `mox` or `.StubOutWithMock()` is used in thin module `m`. */
predicate useOfMoxInModule(Module m) {
  exists(ModuleObject mox | mox.getName() = "mox" or mox.getName() = "mox3.mox" |
    exists(ControlFlowNode use |
      use.refersTo(mox) and
      use.getScope().getEnclosingModule() = m
    )
  )
  or
  exists(Call call |
    call.getFunc().(Attribute).getName() = "StubOutWithMock" and
    call.getEnclosingModule() = m
  )
}
