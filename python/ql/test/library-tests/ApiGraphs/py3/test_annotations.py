from types import AssignmentAnnotation, ParameterAnnotation

def test_annotated_assignment():
    local_x : AssignmentAnnotation = create_x() #$ MISSING: use=moduleImport("types").getMember("AssignmentAnnotation")
    local_x #$ MISSING: use=moduleImport("types").getMember("AssignmentAnnotation").getAnnotatedInstance()

global_x : AssignmentAnnotation #$ use=moduleImport("types").getMember("AssignmentAnnotation")
global_x #$ MISSING: use=moduleImport("types").getMember("AssignmentAnnotation").getAnnotatedInstance()

def test_parameter_annotation(parameter_y: ParameterAnnotation): #$ use=moduleImport("types").getMember("ParameterAnnotation")
    parameter_y #$ use=moduleImport("types").getMember("ParameterAnnotation").getAnnotatedInstance()

type Alias = AssignmentAnnotation

global_z : Alias #$ MISSING: use=moduleImport("types").getMember("AssignmentAnnotation")
global_z #$ MISSING: use=moduleImport("types").getMember("AssignmentAnnotation").getAnnotatedInstance()

def test_parameter_alias(parameter_z: Alias): #$ MISSING: use=moduleImport("types").getMember("AssignmentAnnotation")
    parameter_z #$ MISSING: use=moduleImport("types").getMember("AssignmentAnnotation").getAnnotatedInstance()

# local type aliases
def test_local_type_alias():
    type LocalAlias = AssignmentAnnotation
    local_alias : LocalAlias = create_value() #$ MISSING: use=moduleImport("types").getMember("AssignmentAnnotation")
    local_alias #$ MISSING: use=moduleImport("types").getMember("AssignmentAnnotation").getAnnotatedInstance()
