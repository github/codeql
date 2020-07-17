import python

ModuleValue thePyramidViewModule() { result.getName() = "pyramid.view" }

Value thePyramidViewConfig() { result = thePyramidViewModule().attr("view_config") }

predicate is_pyramid_view_function(Function func) {
  func.getADecorator().pointsTo().getClass() = thePyramidViewConfig()
}
