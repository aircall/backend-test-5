# [Aircall.io](https://aircall.io) - Backend technical test

This test is a part of the hiring process at Aircall for [backend positions](https://jobs.aircall.io).


## Summary

Small Ruby on Rails app to handle basic call forwarding using [twilio](https://twilio.com).

My Twilio number: __+33 6 44 64 75 95__

Basic dashboard to try out all the things: https://backend-test-aircall.herokuapp.com/

Here is the story:

This number is an [IVR](https://en.wikipedia.org/wiki/Interactive_voice_response):
- If the caller presses `1`, call is forwarded to my personal phone number;
- If the caller presses `2`, they are able to leave a voicemail.



### Necessary disclaimer

First attempt at Ruby & Rails, so there may be inconsistent syntaxes all-around, since I do not know yet which are 
the best practices and subtle differences!

- No tests given time constraints
- Used postgres instead of sqlite since Heroku resets local storage once a day!
- Many improvement perspectives in every direction, this is just a (hopefully!) working baseline