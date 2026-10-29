module.exports = {
  inputs: {
    filename: { type: "string", required: true }
  },

  async fn(inputs, exits) {
    return exits.success(inputs.filename);
  }
};
