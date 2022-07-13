# Subclasses

from flask.views import View #$ use=moduleImport("flask").getMember("views").getMember("View")

class MyView(View): #$ use=moduleImport("flask").getMember("views").getMember("View").getASubclass()
    myvar = 45 #$ def=moduleImport("flask").getMember("views").getMember("View").getASubclass().getMember("myvar")
    def my_method(self): #$ def=moduleImport("flask").getMember("views").getMember("View").getASubclass().getMember("my_method")
        return 3 #$ def=moduleImport("flask").getMember("views").getMember("View").getASubclass().getMember("my_method").getReturn()

instance = MyView() #$ use=moduleImport("flask").getMember("views").getMember("View").getASubclass().getReturn()

def internal():
    from pflask.views import View #$ use=moduleImport("pflask").getMember("views").getMember("View")
    class IntMyView(View): #$ use=moduleImport("pflask").getMember("views").getMember("View").getASubclass()
        my_internal_var = 35 #$ def=moduleImport("pflask").getMember("views").getMember("View").getASubclass().getMember("my_internal_var")
        def my_internal_method(self): #$ def=moduleImport("pflask").getMember("views").getMember("View").getASubclass().getMember("my_internal_method")
            pass

    int_instance = IntMyView() #$ use=moduleImport("pflask").getMember("views").getMember("View").getASubclass().getReturn()