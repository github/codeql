---
category: minorAnalysis
---
* The new (shared-CFG-based) Python control flow graph now visits parameter and return type annotations as CFG nodes for function definitions, matching the legacy CFG. This restores annotation-based type tracking through framework models such as FastAPI's `Depends()`, Pydantic request models, Starlette `WebSocket` handlers, and any other models that flow a class reference through `Parameter.getAnnotation()` to identify instances of the annotated class.
