require 'fileutils'
require 'shellwords'

def apply_template
  add_template_repository_to_source_path

  copy_file 'Gemfile.tt', 'Gemfile', force: true

  create_file '.ruby-version', '2.4.2'
  copy_file '.rubocop.yml'
  copy_file 'LICENSE.md'

  copy_file 'app/views/layouts/application.html.erb', force: true
  copy_file 'app/views/layouts/_breadcrumbs.html.erb'
  copy_file 'app/views/layouts/_flash.html.erb'
  copy_file 'app/views/layouts/_global_alert.html.erb'
  copy_file 'app/views/layouts/_google_analytics.html.erb'
  copy_file 'app/views/layouts/_head.html.erb'
  copy_file 'app/views/layouts/_institute_footer.html.erb'
  copy_file 'app/views/layouts/_site_footer.html.erb'
  copy_file 'app/views/layouts/_site_header.html.erb'
  copy_file 'app/assets/images/favicon.ico'

  update_secrets

  copy_file 'app/controllers/application_controller.rb', force: true
  copy_file 'app/assets/stylesheets/layout.css.erb', force: true

  copy_file 'app/controllers/users/omniauth_callbacks_controller.rb'

  create_file 'Procfile' do
    'web: bundle exec puma -C config/puma.rb'
  end

  gsub_file 'Rakefile', /will automatically be/, 'will be'

  append_to_file '.gitignore' do
    "coverage\n.env\n"
  end

  create_file '.env'

  after_bundle do
    generate(:controller, 'static home')
    devise_user
    add_routes
    add_tests
    db_migrate
    run 'bundle exec annotate'
    run 'bundle exec rubocop -a'
    git_commit
  end
end

def update_secrets
  insert_into_file 'config/secrets.yml',
                   "\ncommon: &common\n  oauth_key: <%= ENV['MIT_OAUTH2_API_KEY'] %>\n  oauth_secret: <%= ENV['MIT_OAUTH2_API_SECRET'] %>\n\n",
                   before: "development:\n"

  insert_into_file 'config/secrets.yml', "  <<: *common\n",
                   after: "production:\n", force: true

  insert_into_file 'config/secrets.yml', "  <<: *common\n",
                   after: "development:\n", force: true

  insert_into_file 'config/secrets.yml', "  <<: *common\n",
                   after: "test:\n", force: true
end

def devise_user
  copy_file 'config/initializers/devise.rb'
  copy_file 'app/models/user.rb'
  copy_file 'config/locales/devise.en.yml'
end

def add_routes
  copy_file 'config/routes.rb', force: true
end

def add_puma
  copy_file 'config/puma.rb', force: true
end

def add_tests
  copy_file 'test/test_helper.rb', force: true
  copy_file 'test/controllers/static_controller_test.rb', force: true
  copy_file 'test/features/static_test.rb', force: true
  copy_file 'test/fixtures/users.yml', force: true
  copy_file 'test/integration/authentication_test.rb', force: true
  copy_file 'test/models/user_test.rb', force: true
end

def db_migrate
  copy_file 'db/migrate/20150101010101_devise_create_users.rb'
  run 'rake db:migrate'
end

def git_commit
  git :init
  git add: '.'
  git commit: "-a -m 'Initial commit'"
end

# Add this template directory to source_paths so that Thor actions like
# copy_file and template resolve against our source files. If this file was
# invoked remotely via HTTP, that means the files are not present locally.
# In that case, use `git clone` to download them to a local temporary dir.
# https://github.com/mattbrictson/rails-template/blob/master/template.rb#L65-L86
def add_template_repository_to_source_path
  if __FILE__ =~ %r{\Ahttps?://}
    require "tmpdir"
    source_paths.unshift(tempdir = Dir.mktmpdir("rails-template-"))
    at_exit { FileUtils.remove_entry(tempdir) }
    git :clone => [
      "--quiet",
      "https://github.com/MITLibraries/rails_template.git",
      tempdir
    ].map(&:shellescape).join(" ")

    if (branch = __FILE__[%r{rails-template/(.+)/template.rb}, 1])
      Dir.chdir(tempdir) { git :checkout => branch }
    end
  else
    source_paths.unshift(File.dirname(__FILE__))
  end
end

apply_template
