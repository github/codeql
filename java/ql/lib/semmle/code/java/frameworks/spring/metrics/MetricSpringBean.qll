import semmle.code.java.frameworks.spring.SpringBean
import semmle.code.java.frameworks.spring.SpringBeanFile
import semmle.code.java.frameworks.spring.SpringEntry

predicate springDepends(SpringBean b1, SpringBean b2, SpringXmlElement cause) {
  b1 != b2 and
  b1.getBeanParent() = b2 and
  cause = b1
  or
  exists(SpringAbstractRef ref |
    ref.getEnclosingBean() = b1 and
    ref.getBean() = b2 and
    cause = ref
  )
  or
  exists(SpringConstructorArg arg |
    arg.getEnclosingBean() = b1 and
    arg.getArgRefBean() = b2 and
    cause = arg
  )
  or
  exists(SpringEntry entry |
    entry.getEnclosingBean() = b1 and
    (
      entry.getKeyRefBean() = b2 or
      entry.getValueRefBean() = b2
    ) and
    cause = entry
  )
  or
  exists(SpringProperty prop |
    prop.getEnclosingBean() = b1 and
    prop.getPropertyRefBean() = b2 and
    cause = prop
  )
}

class MetricSpringBean extends SpringBean {
  int getAfferentCoupling() { result = count(SpringBean other | springDepends(other, this, _)) }

  int getEfferentCoupling() { result = count(SpringBean other | springDepends(this, other, _)) }

  int getLocalAfferentCoupling() {
    result =
      count(SpringBean other |
        springDepends(other, this, _) and
        this.getSpringBeanFile() = other.getSpringBeanFile()
      )
  }

  int getLocalEfferentCoupling() {
    result =
      count(SpringBean other |
        springDepends(this, other, _) and
        this.getSpringBeanFile() = other.getSpringBeanFile()
      )
  }

  SpringBean getABeanDependency() { springDepends(this, result, _) }

  SpringBean getALocalBeanDependency() {
    springDepends(this, result, _) and
    this.getSpringBeanFile() = result.getSpringBeanFile()
  }

  SpringXmlElement getBeanDependencyCause(SpringBean dependency) {
    springDepends(this, dependency, result)
  }
}
