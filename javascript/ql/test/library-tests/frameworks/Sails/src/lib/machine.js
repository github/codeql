module.exports = {
  inputs: {
    filename: { type: "string", required: true }
  },

  fn(inputs, exits) {
    return exits.success(inputs.filename);
  }
};
