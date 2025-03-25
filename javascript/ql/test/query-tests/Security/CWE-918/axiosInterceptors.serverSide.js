const express = require("express");
const axios = require("axios");

const app = express();

let userProvidedUrl = "";

axios.interceptors.request.use(
    function (config) {
        if (userProvidedUrl) {
            config.url = userProvidedUrl; // $ Alert[js/request-forgery]
        }
        return config;
    },
    error => error
);

app.post("/fetch", (req, res) => {
    const { url } = req.body; // $ Source[js/request-forgery]
    userProvidedUrl = url; 
    axios.get("placeholder");
});
