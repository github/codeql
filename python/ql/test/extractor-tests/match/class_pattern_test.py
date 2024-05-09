match x:
    case MyClass.SubClass(prop = x):
        pass

    case MyClass(sub = None):
        pass
