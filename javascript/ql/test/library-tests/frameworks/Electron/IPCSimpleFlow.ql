
import javascript

from DataFlow::Node pred, DataFlow::Node succ, string channel
where Electron::ipcSimpleFlowStep(pred, succ, channel)
select pred, succ, channel
