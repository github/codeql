
import javascript

from DataFlow::Node pred, DataFlow::Node succ, string channel
where Electron::IPC::simpleFlowStep(pred, succ, channel)
select pred, succ, channel
