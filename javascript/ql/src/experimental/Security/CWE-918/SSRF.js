const axios = require('axios');

export const handler = async (req, res, next) => {
  const { target } = req.body;

  try {
    // BAD: `target` is controlled by the attacker
    const response = await axios.get('https://example.com/current_api/' + target);

    // process request response
    use(response);
  } catch (err) {
    // process error
  }
};
