import python

abstract class Template extends Module { }

class SpitfireTemplate extends Template {
  SpitfireTemplate() { this.getKind() = "Spitfire template" }
}

class PyxlModule extends Template {
  PyxlModule() {
    exists(Comment c | c.getLocation().getFile() = this.getFile() |
      c.getText().regexpMatch("# *coding.*pyxl.*")
    )
  }
}
