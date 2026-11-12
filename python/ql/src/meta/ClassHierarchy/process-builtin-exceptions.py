from shared_subclass_functions import write_data_extension
import sys
from pathlib import Path

py_version = sys.version.split()[0]
VERSION = f"process-builtin-exceptions 0.0.1; Python {py_version}"

builtins_model_path = Path(__file__).parent.parent.parent.parent / "lib/semmle/python/frameworks/builtins.model.json"


builtin_names = dir(__builtins__)
builtin_dict = {x: getattr(__builtins__,x) for x in builtin_names}


builtin_exceptions = {v for v in builtin_dict.values() if type(v) is type and issubclass(v, BaseException)}

data = []
for sub in builtin_exceptions:
    for base in sub.__mro__:
        if issubclass(base, BaseException):
            basename = base.__name__ 
            subname = sub.__name__ 
            row = [f"builtins.{basename}~Subclass", f"builtins.{subname}", ""]
            data.append(row)
            
write_data_extension(data, VERSION, builtins_model_path)
