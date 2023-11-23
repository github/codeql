private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.ApiGraphs

/**
 * A data-flow node that constructs a template.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `TemplateConstruction::Range` instead.
 */
class TemplateConstruction extends DataFlow::Node instanceof TemplateConstruction::Range {
  /** Gets the argument that specifies the template source. */
  DataFlow::Node getSourceArg() { result = super.getSourceArg() }
}

/** Provides a class for modeling new system-command execution APIs. */
module TemplateConstruction {
  /**
   * A data-flow node that constructs a template.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `TemplateConstruction` instead.
   */
  abstract class Range extends DataFlow::Node {
    /** Gets the argument that specifies the template source. */
    abstract DataFlow::Node getSourceArg();
  }
}

// -----------------------------------------------------------------------------
/** A call to `airspeed.Template`. */
class AirspeedTemplateConstruction extends TemplateConstruction::Range, API::CallNode {
  AirspeedTemplateConstruction() {
    this = API::moduleImport("airspeed").getMember("Template").getACall()
  }

  override DataFlow::Node getSourceArg() { result = this.getArg(0) }
}

/** A call to `bottle.SimpleTemplate`. */
class BottleSimpleTemplateConstruction extends TemplateConstruction::Range, API::CallNode {
  BottleSimpleTemplateConstruction() {
    this = API::moduleImport("bottle").getMember("SimpleTemplate").getACall()
  }

  override DataFlow::Node getSourceArg() { result = this.getArg(0) }
}

/** A call to `bottle.template`. */
class BottleTemplateConstruction extends TemplateConstruction::Range, API::CallNode {
  BottleTemplateConstruction() {
    this = API::moduleImport("bottle").getMember("template").getACall()
  }

  override DataFlow::Node getSourceArg() { result = this.getArg(0) }
}

/** A call to `chameleon.PageTemplate`. */
class ChameleonTemplateConstruction extends TemplateConstruction::Range, API::CallNode {
  ChameleonTemplateConstruction() {
    this = API::moduleImport("chameleon").getMember("PageTemplate").getACall()
  }

  override DataFlow::Node getSourceArg() { result = this.getArg(0) }
}

/** A call to `Cheetah.Template.Template`. */
class CheetahTemplateConstruction extends TemplateConstruction::Range, API::CallNode {
  CheetahTemplateConstruction() {
    this =
      API::moduleImport("Cheetah")
          .getMember("Template")
          .getMember("Template")
          .getASubclass*()
          .getACall()
  }

  override DataFlow::Node getSourceArg() { result = this.getArg(0) }
}

/** A call to `chevron.render`. */
class ChevronRenderConstruction extends TemplateConstruction::Range, API::CallNode {
  ChevronRenderConstruction() { this = API::moduleImport("chevron").getMember("render").getACall() }

  override DataFlow::Node getSourceArg() { result = this.getArg(0) }
}

/** A call to `django.template.Template` */
class DjangoTemplateConstruction extends TemplateConstruction::Range, API::CallNode {
  DjangoTemplateConstruction() {
    this = API::moduleImport("django").getMember("template").getMember("Template").getACall()
  }

  override DataFlow::Node getSourceArg() { result = this.getArg(0) }
}

// TODO: support django.template.engines["django"]].from_string
/** A call to `flask.render_template_string`. */
class FlaskTemplateConstruction extends TemplateConstruction::Range, API::CallNode {
  FlaskTemplateConstruction() {
    this = API::moduleImport("flask").getMember("render_template_string").getACall()
  }

  override DataFlow::Node getSourceArg() { result = this.getArg(0) }
}

/** A call to `genshi.template.TextTemplate`. */
class GenshiTextTemplateConstruction extends TemplateConstruction::Range, API::CallNode {
  GenshiTextTemplateConstruction() {
    this = API::moduleImport("genshi").getMember("template").getMember("TextTemplate").getACall()
  }

  override DataFlow::Node getSourceArg() { result = this.getArg(0) }
}

/** A call to `genshi.template.MarkupTemplate` */
class GenshiMarkupTemplateConstruction extends TemplateConstruction::Range, API::CallNode {
  GenshiMarkupTemplateConstruction() {
    this = API::moduleImport("genshi").getMember("template").getMember("MarkupTemplate").getACall()
  }

  override DataFlow::Node getSourceArg() { result = this.getArg(0) }
}

/** A call to `jinja2.Template`. */
class Jinja2TemplateConstruction extends TemplateConstruction::Range, API::CallNode {
  Jinja2TemplateConstruction() {
    this = API::moduleImport("jinja2").getMember("Template").getACall()
  }

  override DataFlow::Node getSourceArg() { result = this.getArg(0) }
}

/** A call to `jinja2.from_string`. */
class Jinja2FromStringConstruction extends TemplateConstruction::Range, API::CallNode {
  Jinja2FromStringConstruction() {
    this = API::moduleImport("jinja2").getMember("from_string").getACall()
  }

  override DataFlow::Node getSourceArg() { result = this.getArg(0) }
}

/** A call to `mako.template.Template`. */
class MakoTemplateConstruction extends TemplateConstruction::Range, API::CallNode {
  MakoTemplateConstruction() {
    this = API::moduleImport("mako").getMember("template").getMember("Template").getACall()
  }

  override DataFlow::Node getSourceArg() { result = this.getArg(0) }
}

/** A call to `trender.TRender`. */
class TRenderTemplateConstruction extends TemplateConstruction::Range, API::CallNode {
  TRenderTemplateConstruction() {
    this = API::moduleImport("trender").getMember("TRender").getACall()
  }

  override DataFlow::Node getSourceArg() { result = this.getArg(0) }
}
