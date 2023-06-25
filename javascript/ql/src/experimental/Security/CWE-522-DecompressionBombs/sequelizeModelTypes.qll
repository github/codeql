import javascript
import DataFlow

module SequelizeModel {
  SourceNode sequelizeModelAsSourceNode(TypeTracker t) {
    t.start() and
    exists(
      DataFlow::ClassNode baseModelFirstDirectChild, DataFlow::ClassNode baseModelAllLevelSubClasses
    |
      DataFlow::moduleMember("sequelize-typescript", "Model")
          .flowsTo(baseModelFirstDirectChild.getASuperClassNode()) and
      baseModelAllLevelSubClasses = baseModelFirstDirectChild.getADirectSubClass*() and
      result = baseModelAllLevelSubClasses
    )
    or
    exists(TypeTracker t2 | result = sequelizeModelAsSourceNode(t2).track(t2, t))
  }

  SourceNode sequelizeModelAsSourceNode() {
    result = sequelizeModelAsSourceNode(TypeTracker::end())
  }
}
