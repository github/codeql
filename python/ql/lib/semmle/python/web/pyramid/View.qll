import python

deprecated ModuleValue thePyramidViewModule() { result.getName() = "pyramid.view" }

deprecated Value thePyramidViewConfig() { result = thePyramidViewModule().attr("view_config") }

deprecated predicate is_pyramid_view_function(Function func) {
  func.getADecorator().pointsTo().getClass() = thePyramidViewConfig()
}
