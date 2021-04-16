# Donut Project

This is a Sinatra application that uses the [Starter Slack Template](https://github.com/donut-ai/slack-app-template)
from Donut.

## Running the App
Install [Bundler](https://bundler.io/):
```
gem install bundler
```
Install all the required gems:
```
bundle install
```
Start the server using [Rack](https://github.com/rack/rack) to be able to intercept
`binding.pry` breakpoint.

Run the app:

```
rackup config.ru -p 4567
```

## Project Donut setup
I created a task controller for this project to be able to process all requests
made to the `/tasks` endpoint.

The slack bot is configured to make requests to the following endpoint:
http://d1d261e01fd3.ngrok.io/tasks

NOTE: This endpoing can changed and is provided by [ngrok](https://ngrok.com/).
For more information check the [ngrok documentation](https://ngrok.com/docs)

### Challenges
It seems that the design for this project followed an
[RPC](https://www.smashingmagazine.com/2016/09/understanding-rest-and-rpc-for-http-apis/#:~:text=RPC%2Dbased%20APIs%20are%20great,through%20mainly%20CRUD%2Dbased%20operations.) architecture since the requests were being made to a single endpoint.
Althought I often follow the RESTful style I think I was able to handle this
correctly. I created a Handler class to encapsulate the requirements for
processing the requests made by the Slack API.

### Beta-2.0.0
With more time I will improve the following:
* Create tests
* Improve error handling using rescue and creating descriptive error classes.

