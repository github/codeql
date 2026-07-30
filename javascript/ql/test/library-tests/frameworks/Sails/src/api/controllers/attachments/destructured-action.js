module.exports = {
  inputs: {
    filename: { type: "string", required: true }
  },

  async fn({ filename }, exits) {
    return exits.success(filename);
  }
};
