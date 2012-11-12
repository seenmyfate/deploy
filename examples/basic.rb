require_relative '../lib/deploy'

deploy = Deploy::Builder.new do |b|
  b.use Deploy::Git::Pull, repo: 'git@github.com:seenmyfate/my_repo.git'
  b.use Deploy::Bundle::Install
  b.use Deploy::Rake::Migrate
  b.use Deploy::Unicorn::Restart
  b.use Deploy::Notification::Twitter
end


sandbox = Deploy::Env.new(:sandbox) do |env|
  env.role :app, %w{example.com}
  env.role :web, %w{example.com}
  env.role :db, %w{example.com}

  env.user 'tomc'
  env.path '/var/www/my_app/current'
  env.backend 'SSH'
end

Deploy::Runner.new(sandbox).run(deploy)
