const action = {
  inputs: {
    name: { type: "string", required: true }
  },

  fn(inputs, exits) {
    return exits.success(inputs.name);
  }
};

module.exports = action;
