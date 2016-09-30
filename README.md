# Errdo
[![Gem Version](https://badge.fury.io/rb/errdo.svg)](https://badge.fury.io/rb/errdo)
![master build](https://travis-ci.org/erichaydel/errdo.svg?branch=master)
[![Code Climate](https://codeclimate.com/github/erichaydel/errdo/badges/gpa.svg)](https://codeclimate.com/github/erichaydel/errdo)
[![Test Coverage](https://codeclimate.com/github/erichaydel/errdo/badges/coverage.svg)](https://codeclimate.com/github/erichaydel/errdo/coverage)

Because sometimes your users get ERRors, and you want to DO something about it.

This gem is meant to be an simple all-in-one error solution for your rails application. It's an alternative to the complications of installing multiple gems to track, record, and notify yourself of errors that your users encounter. (Or paying for a big solution when you only want something simple.)

I'm a big believer that every single app with a production server, whether it has users or not, should have some way to track errors. It leads to better code and can prevent a critical error from causing a mass exodus of users (something I have personal experience with).

Big thanks to the contributors to the rails admin and devise gems, whose beautiful code has been very helpful in trying to make this gem as modular and expandable as possible.

To the good part.

## Quickstart Guide

Put `gem 'errdo'` in your Gemfile and run `bundle install`

Next, you need to run the installer with

`$ rails generate errdo:install`

This will create an initializer called "errdo.rb" with configuration options inside. It's useful to read these options to customize to get exactly what you want.

If you want to log the errors into a database, you'll now need to run

`$ rails generate errdo MODEL`
where MODEL is the optional error name you want to log. If left blank, it will default to "error".
Run
`rake db:migrate`

To be able to see a list of all the errors in your application, mount the engine:
` mount Errdo::Engine => "/errdo"`
where you can replace "/errdo" with whatever you want.

To link the error index page in your application, the route will be
`errdo.root_path`

This should be good enough to get everything working on a basic level.

To test this in your development environment, make sure you set
`config.consider_all_requests_local = true`
in your `development.rb`

And then, you know, break something.

## Authentication

To authenticate, you must pass a block to the authenticate_with method in the initializer. If you're using devise, the simple command is
```
config.authenticate_with do
      warden.authenticate! scope: :user
end
```
Otherwise, you'll want to pass a block that authenticates the current user.

To keep track of the user that encounters an error, you'll want to set the current_user method in the initializer.

By default, it's nil, which means that logged in users aren't recorded with the errors (Though the user-agent always is).

If you want to be able to link to your user's page (and have it clickable from the error index page for quick navigation), set the
`config.user_show_path`
to the URL helper for your user's show page. For example, in a normal application, this would be
`:user_path`

## Authorization

You probably don't want to rely on obfuscation to stop users from seeing your developer/admin side error index table.

Similarly to authentication, you can pass a block to authorize with. For example, you can pass a direct redirect call:
```
config.authorize_with do
  redirect_to root_path unless warden.user.try(:is_admin?)
end
```

 If you're using [CanCanCan](https://github.com/CanCanCommunity/cancancan), you can just pass `:cancan` as an option:
 `config.authorize_with :cancan`

## Notification Integrations

Right now, only slack is supported.

#### Slack
 To get this working, you must set up a slack integration on your team's slack page.

To get webhook url you need:

1. Go to https://slack.com/apps/A0F7XDUAZ-incoming-webhooks
2. Choose your team, press configure
in configurations press add configuration
3. Choose channel, press "Add Incoming WebHooks integration"

Now, set a hash of all your slack values
```
Errdo.notify_with slack: {  webhook: "WEBHOOK-URL",
                            icon: ":boom:"}
```

You can set a custom slack emoji icon and name for the bot that posts in your channel. See the initializer for more information.

In the future, more keys will be added to this hash for more integrations. Working on it!

## Sanitization
By default, the words
`password
passwd
password_confirmation
secret
confirm_password
secret_token`
 are all scrubbed from the params before storing the error in the database. If you need something else scrubbed, let me know and I can add it.

 To customize this, add params with

 `# Errdo.dirty_words += ["custom_param"]`

 in the config file.

## Contributing

If there's a big feature you want, I would hope you would consider contributing.

This gem happens on the brink of failure in the app. Exceptions in this gem lead to bad user experience, so everything is very well tested in minitest. Everything submitted should have 95%+ code test coverage, at the very least.

As far as style, I follow a subset of the [ruby style guide](https://github.com/bbatsov/ruby-style-guide). There's a rubocop file in the repo that's customized. I would highly appreciate if it you follow the style guide, to keep things clean. Honestly, though, I probably won't reject something just because of style.

That being said, I would love your help!

### *Bug reports*
Because bugs are so catastrophic at this level of the app, I would really really really appreciate it if you could submit bugs that you encounter. I will be able to get to them quickly.

### *Being mean to my code*
I'm doing this project as a fun side project, so I'm trying to make the code as beautiful and DRY as possible. If you have a good time ripping apart people's code, feel free to message me with any things you think I can do better in the app. I love to learn and I would love to hear your feedback.

### *Suggestions*
If you think of something cool that you would use in your app, let me know on github preferably, even if you don't want to work on it! I'm always open to new ideas.

## Future things I want to do
1. More notification integrations
2. Be able to create rules about when a notification is delivered (For example, maybe users identified as admins don't create notifications)
3. Customizable index page
4. Backtrace silencer integration
5. Better index page with more stats

This project rocks and uses MIT-LICENSE.
