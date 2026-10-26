import python
import semmle.python.frameworks.Flask
import semmle.python.ApiGraphs
import experimental.meta.InlineInstanceTest

API::Node getInstance() { result = Flask::FlaskApp::instance() }

import MakeInlineInstanceTest<getInstance/0>
