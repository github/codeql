class Annotation:
    #...
    pass

def print_annotation(annotation):
    print("Message: " + annotation.message)
    print("Line: " + annotation.line)
    print("Offset: " + annotation.offset)
    print("Length: " + annotation.length)
