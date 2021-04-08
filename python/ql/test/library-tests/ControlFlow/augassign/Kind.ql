import python

string kind(ControlFlowNode f) {
  if f.isAugLoad()
  then result = "aug load"
  else (
    if f.isAugStore()
    then result = "aug store"
    else (
      if f.isLoad() then result = "load" else (f.isStore() and result = "store")
    )
  )
}

from ControlFlowNode cfg
select cfg.getLocation().getStartLine(), cfg, kind(cfg)
