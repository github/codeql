const axios = require('axios');
const validator = require('validator');

export const handler = async (req, res, next) => {
  const { target } = req.body;

  if (!validator.isAlphanumeric(target)) {
    return next(new Error('Bad request'));
  }

  try {
    // `target` is validated
    const response = await axios.get('https://example.com/current_api/' + target);

    // process request response
    use(response);
  } catch (err) {
    // process error
  }
};
