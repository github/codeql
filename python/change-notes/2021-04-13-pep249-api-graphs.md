lgtm,codescanning
* Modeling of libraries supporting PEP249 has been changed to use API graphs. When defining new
  models, the relevant extension point is now `PEP249ModuleApiNode` in the `PEP249` module, instead
  of `PEP249Module`. The latter class has now been deprecated.
