class PythonModule(_ModuleIteratorHelper): # '_ModuleIteratorHelper' and 'PythonModule' are old-style classes

    # class definitions ....

    def walkModules(self, importPackages=False):
        if importPackages and self.isPackage():
            self.load()
        return super(PythonModule, self).walkModules(importPackages=importPackages) # super() will fail


class PythonModule2(_ModuleIteratorHelper): # call to super replaced with direct call to class

    # class definitions ....

    def walkModules(self, importPackages=False):
        if importPackages and self.isPackage():
            self.load()
        return _ModuleIteratorHelper.__init__(PythonModule, self).walkModules(importPackages=importPackages)
