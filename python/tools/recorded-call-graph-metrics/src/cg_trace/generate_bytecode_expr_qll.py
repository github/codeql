import dataclasses
from typing import Any, List

from cg_trace.bytecode_reconstructor import BytecodeExpr

PREAMBLE = """\
import python

abstract class XMLBytecodeExpr extends XMLElement { }
"""

CLASS_PREAMBLE = """\
class XML{class_name} extends XMLBytecodeExpr {{
  XML{class_name}() {{ this.hasName("{class_name}") }}
"""

CLASS_AFTER = """\
}
"""

ATTR_TEMPLATES = {
    str: 'string get_{name}_data() {{ result = this.getAChild("{name}").getTextValue() }}',
    int: 'int get_{name}_data() {{ result = this.getAChild("{name}").getTextValue().toInt() }}',
    BytecodeExpr: 'XMLBytecodeExpr get_{name}_data() {{ result.getParent() = this.getAChild("{name}") }}',
    List[
        BytecodeExpr
    ]: 'XMLBytecodeExpr get_{name}_data(int index) {{ result = this.getAChild("{name}").getChild(index) }}',
    Any: 'string get_{name}_data_raw() {{ result = this.getAChild("{name}").getTextValue() }}',
}

if __name__ == "__main__":

    print(PREAMBLE)

    for sc in BytecodeExpr.__subclasses__():
        print(CLASS_PREAMBLE.format(class_name=sc.__name__))

        for f in dataclasses.fields(sc):
            field_template = ATTR_TEMPLATES.get(f.type)
            if field_template:
                generated = field_template.format(name=f.name)
                print(f"  {generated}")
            else:
                raise Exception("no template for", f.type)

        print(CLASS_AFTER)
