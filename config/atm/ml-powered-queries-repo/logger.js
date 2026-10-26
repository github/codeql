module.exports.Logger = class {
  log(message, ...objs) {
    console.log(message, objs);
  }
};
