# Rails App Generator with MIT Oauth

This command with create and configure a new Rails app with MIT Oauth.

```
rails new some_app_name --skip-turbolinks --skip-spring -m https://raw.githubusercontent.com/MITLibraries/rails_template/master/template.rb
```

## post install
- `cd some_app_name`
- add MIT OAuth credentials to `.env`
- `bin/rake` runs the tests
- `heroku local` will run dev instance with `.env`

## pre-requisites
- ruby (latest is best)
- rails 4.2.x installed (`gem install rails`)
- heroku toolbelt


NOTE: please ask questions on Slack or open Issues for bugs (or PRs for bug fixes!)
