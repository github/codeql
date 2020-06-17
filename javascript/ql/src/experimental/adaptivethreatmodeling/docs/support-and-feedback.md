# Support and feedback

We're eager to help you use adaptive threat modeling (ATM) and learn from your experiences of using ATM to find new security vulnerabilities. Your feedback will help us to improve ATM and contribute to securing the world's software. 

## How do I get help?

You should have access to the Slack channel [`#codeql-atm-beta`](https://ghsecuritylab.slack.com/archives/C011BJD7279) on the GitHub Security Lab Slack instance. Please raise any issues there, and the ATM team will get back to you as quickly as possible.

## How can I give feedback?
 
We'd like as much feedback on ATM as you're willing to give. But we know your time is precious. So here's a list of suggested feedback items, ordered from quick to a (bit) longer.

- Say hi on `#codeql-atm-beta` with a short sentence to explain why you're interested in ATM. This will help us gauge the interest in advanced security features.

- Share examples of boosted queries. We're interested in how you generate known endpoints, and what kinds of endpoint filters turn out to be useful.

- Once you've completed your experiments with ATM, please answer the following questions, and share on the channel:

    1. Did you find security vulnerabilities with ATM? (yes or no)

    2. What do you like best about ATM?

    3. What would you most like to improve about ATM?

    4. How useful is ATM to you? Answer from 1 to 5 (1 = "definitely useful", 5 = "definitely not useful")

    5. How likely would you be to recommend ATM to a colleague?
        Answer from 1 to 5 (1 = "extremely likely", 5 = "not at all likely").

- Share any vulnerabilities you find (that you can disclose) by privately emailing `codeql-atm-beta@github.com`. We'd like to understand the efficacy of different types of boosted queries. Please tell us (i) which repos you ran the query against, (ii) the number of alerts generated, (iii) how many you manually checked, and (iv) how many of those turned out to be actual vulnerabilities (whether exploitable or not). We don’t expect you to eyeball all the results, so it makes sense to sub-sample with a bias towards alerts with higher scores. Complete a table, with a row for every repo you run the query against, and email us. For example:

    | URL of repo (if open source) or short description (if closed source) | # alerts | # alerts checked | # true positives |
    |----------------------------------------------------------------------|----------|------------------|------------------|
    | https://github.com/example1/example1                                 | 97       | 10               | 1                |
    | https://github.com/example2/example2                                 | 120      | 11               | 2                |
