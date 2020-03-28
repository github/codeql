import javascript

from UriLibraryStep step, DataFlow::Node pred, DataFlow::Node succ
where step.step(pred, succ)
select pred, succ
