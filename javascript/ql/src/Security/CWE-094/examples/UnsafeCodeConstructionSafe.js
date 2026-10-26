export function safeDeserialize(value) {
  return JSON.parse(value);
}

const _ = require("lodash");
export function safeGetter(object, path) {
  return _.get(object, path);
}
