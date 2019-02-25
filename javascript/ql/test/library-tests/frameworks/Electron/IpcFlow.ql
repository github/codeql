import javascript

class TestConfig extends DataFlow::Configuration {
  TestConfig() { this = "TestConfig" }
}

from TestConfig cfg, DataFlow::Node pred, DataFlow::Node succ
where cfg.isAdditionalFlowStep(pred, succ)
select pred, succ
