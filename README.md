# Deploy  [![Build Status](https://travis-ci.org/seenmyfate/deploy.png?branch=master)](http://travis-ci.org/seenmyfate/deploy) [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/seenmyfate/deploy)

This project fell out of the early spikes undertaken as part of the [Capistrano v3 project](https://github.com/capistrano/capistrano).
I was interested in looking at the possibility of using the middleware pattern that underpins [Vagrant](https://github.com/mitchellh/vagrant) for building a modular deployment, and this is the end result.
Although this project will deploy code, I wouldn't recommend actually using it for anything.

## Installation

    gem install deploy

## Usage

    require 'deploy'

    # build a strategy for deployment
    # each middleware will be executed in order of inclusion

    deploy = Deploy::Builder.new do |b|
      b.use Deploy::Git::Pull, repo: 'git@github.com:seenmyfate/my_repo.git'
      b.use Deploy::Bundle::Install
      b.use Deploy::Rake::Migrate
      b.use Deploy::Unicorn::Restart
      b.use Deploy::Notification::Twitter
    end

    # describe the environment

    sandbox = Deploy::Env.new(:sandbox) do |env|
      env.role :app, %w{example.com}
      env.role :web, %w{example.com}
      env.role :db, %w{example.com}

      env.user 'tomc'
      env.path '/var/www/my_app/current'
      env.backend 'SSH'
    end

    # run the deployment
    Deploy::Runner.new(sandbox).run(deploy)

Middleware can be nested:

    prerequisites = Deploy::Builder.new do |b|
      b.use Deploy::FolderTree
      b.use Deploy::Shared 'bundle', 'config'
      b.use Deploy::Git::Clone
    end

    deploy = Deploy::Builder.new do |b|
      b.use prerequisites
      b.use Deploy::Git::Pull, repo: 'git@github.com:seenmyfate/my_repo.git'
      b.use Deploy::Bundle::Install
      b.use Deploy::Rake::Migrate
    end


## Contributing to Deploy

* Open a pull request
* Fork the project
* Start a feature/fix branch
* Commit and push until you are happy with your contribution
* Update your pull request

Or use [give](https://github.com/seenmyfate/give)

== Copyright

Copyright (c) 2012 Tom Clements. See LICENSE.txt for
further details.

