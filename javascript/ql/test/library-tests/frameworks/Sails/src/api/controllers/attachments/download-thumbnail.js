module.exports = {
  inputs: {
    id: { type: "string", regex: /^[0-9]+$/, required: true },
    filename: { type: "string", required: true }
  },

  async fn(inputs, exits) {
    const id = inputs.id;
    const filename = inputs.filename;
    const notDeclared = inputs.notDeclared;

    return exits.success({ id, filename, notDeclared });
  }
};
