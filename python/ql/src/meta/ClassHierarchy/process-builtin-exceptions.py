from shared_subclass_functions import wrap_in_template
import sys
import yaml
from pathlib import Path

py_version = sys.version.split()[0]
VERSION = f"process-builtin-exceptions 0.0.1; Python {py_version}"

builtins_model_path = Path(__file__).parent.parent.parent.parent / "lib/semmle/python/frameworks/builtins.model.yml"

def write_data(data, path: Path):
    f = path.open("w+")
    f.write(f"# {VERSION}\n")
    yaml.dump(data, indent=2, stream=f, Dumper=yaml.CDumper)

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
            
write_data(wrap_in_template(data), builtins_model_path)
