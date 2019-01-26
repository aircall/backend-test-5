# OzoneCall

This is my implementation of the [Aircall](https://aircall.io) [backend test 5](https://github.com/aircall/backend-test-5).

## How to deploy on heroku

* Set the required environment variables (see the *application.sample.yml* file)
* Migrate the PG database: `heroku run rake db:migrate`
* Update the Twilio webhooks URL: `heroku run rake voip:update_webhooks` if necessary


[Original *README.md*](./subject.md)