import experimental.dataflow.testConfig

from DataFlow::PostUpdateNode pun
select pun, pun.getPreUpdateNode()
