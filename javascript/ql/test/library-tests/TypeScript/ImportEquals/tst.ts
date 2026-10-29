import ESDefaultExport = require('./esDefaultExport');
import esNamed = require('./esNamedExports');
import NodeFullExport = require('./nodeFullExport');
import nodeNamed = require('./nodeNamedExport');
import external = require('external');

new ESDefaultExport();
new esNamed.ESNamedExport1();
new esNamed.ESNamedExport2();
new NodeFullExport();
new nodeNamed.NodeNamedExport();
new external();
new external.member();


import taintSource = require('./taintSource');
import externalTaintSink = require('externalTaintSink');
externalTaintSink(taintSource.taintedValue);
