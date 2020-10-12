import javascript

from DataFlow::ClassNode cls, string name
select cls, name, cls.getFieldTypeAnnotation(name)
