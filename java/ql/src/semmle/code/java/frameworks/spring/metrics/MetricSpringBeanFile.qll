import semmle.code.java.frameworks.spring.SpringBean
import semmle.code.java.frameworks.spring.SpringBeanFile
import semmle.code.java.frameworks.spring.metrics.MetricSpringBean

class MetricSpringBeanFile extends SpringBeanFile {
  SpringBeanFile getASpringBeanFileDependency() {
    exists(SpringBean b1, SpringBean b2 |
      b1.getSpringBeanFile() = this and
      b2.getSpringBeanFile() = result and
      springDepends(b1, b2, _)
    )
  }

  int getAfferentCoupling() {
    result = count(MetricSpringBeanFile other | other.getASpringBeanFileDependency() = this)
  }

  int getEfferentCoupling() { result = count(this.getASpringBeanFileDependency()) }
}
