# Rails App Generator with MIT Oauth and Branding

## Pre-requisites
- ruby (latest is best)
- rails 5.1.x installed (`gem install rails`)
- heroku toolbelt
- a vagrant box configuration is maintained that provides those requirements
  but is not strictly required
  [MIT Vagrant Rails](https://github.com/JPrevost/mit_vagrant_rails)

## Creating a New Rails App with this template
This command with create and configure a new Rails app with MIT OpenID Pilot
and MIT Libraries branding.
.

```
rails new some_app_name --skip-turbolinks --skip-spring -m https://raw.githubusercontent.com/MITLibraries/rails_template/master/template.rb
```

## post install
- `cd some_app_name`
- add MIT OAuth credentials to `.env`
- `bin/rake` runs the tests
- `heroku local` will run dev instance with `.env`

## Environment Variables for the resulting application
- `FAKE_AUTH_ENABLED`: if set uses dev mode authorization instead of Pilot
auth. This should _never_ be used in production / staging and _may_ be
dangerous in PR builds depending on how you connect to backend systems (if real
systems for PR builds do _NOT_ use this feature!!!). If you are unsure, it's
probably not safe to use as it allows any username/password to login with admin
rights. For apps with extremely sensitive data it may be best to remove all
remnants of this feature _or_ add in additional safeguards.
- `GLOBAL_ALERT`: HTML message to display as a top level banner (if present).
- `GOOGLE_ANALYTICS`: GA property to use. If unset no analytics tracking is provided. If set, it uses this property ID.

## Questions? Need help?

Please ask on Slack or open Issues for bugs (or PRs for bug fixes!)
