import { map as map1 } from "lodash";
import { map as map2 } from "underscore";
import map3 from "lodash/map";
import map4 from "lodash.map";
let lodash = require('lodash');
let underscore = require('underscore');

function f(x) {
  map1(x);
  map2(x);
  map3(x);
  map4(x);
  lodash.map(x);
  underscore.map(x);
}
