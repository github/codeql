const express = require("express");
const axios = require("axios");

const app = express();

let userProvidedUrl = "";

axios.interceptors.request.use(
    function (config) {
        if (userProvidedUrl) {
            config.url = userProvidedUrl; // $ MISSING: Alert[js/request-forgery]
        }
        return config;
    },
    error => error
);

app.post("/fetch", (req, res) => {
    const { url } = req.body; // $ MISSING: Source[js/request-forgery]
    userProvidedUrl = url; 
    axios.get("placeholder");
});
