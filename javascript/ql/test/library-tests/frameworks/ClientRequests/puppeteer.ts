import * as puppeteer from 'puppeteer';

(async () => {
    const browser = await puppeteer.launch();
    const page = await browser.newPage();
    await page.goto('https://example.com');

    page.addStyleTag({ url: "http://example.org/style.css" })
})();

class Renderer {
    private browser: puppeteer.Browser;
    constructor(browser: puppeteer.Browser) {
        this.browser = browser;
    }
    async foo(requestUrl: string): Promise<void> {
        const page = await this.browser.newPage();
        let response = await page.goto(requestUrl);
    }
}