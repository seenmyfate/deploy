require_relative '../lib/deploy'

prequisites = Deploy::Builder.new do |b|
  b.use Deploy::System::Check
  b.use Deploy::File::Tree
  b.use Deploy::Git::Clone, repo: 'git@github.com:seenmyfate/my_repo.git'
  b.use Deploy::File::Symlink
end

update_code = Deploy::Builder.new do |b|
  b.use Deploy::Git::Pull
  b.use Deploy::Bundle::Install
end

run_migrations = Deploy::Builder.new do |b|
  b.use Deploy::Maintenance::On
  b.use Deploy::Rake::Migrate
  b.use Deploy::Unicorn::Restart
  b.use Deploy::Maintenance::Off
end

notify_the_world = Deploy::Builder.new do |b|
  b.use Deploy::Notification::Twitter
  b.use Deploy::Notification::Email
  b.use Deploy::Notification::NewRelic
  b.use Deploy::Notification::Airbrake
  b.use Deploy::Notification::Campfire
end

downtime_deploy = Deploy::Builder.new do |b|
  b.use prequisites
  b.use update_code
  b.use run_migrations
  b.use notify_the_world
end

sandbox = Deploy::Env.new(:sandbox) do |env|
  env.role :app, %w{example.com}
  env.role :web, %w{example.com}
  env.role :db, %w{example.com}

  env.log_level = 2
  env.user 'tomc'
  env.path '/var/www/my_app'
  env.backend 'SSH'
end

Deploy::Runner.new(sandbox).run(downtime_deploy)
