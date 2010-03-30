# Mysql Tasks plugin

A collection of Rake and Capistrano tasks for Rails applications running on
MySQL databases

## Use

The two tasks I use most are

1. rake mysql:console

  Which drops you into a MySQL console session, connected to your rails
  applications database

2. rake mysql:refresh\_from\_production

  Which takes a snapshot of your production database, downloads it and loads it
  into your local development database.

## Requirements

To make use of the tasks that access your production application you will need
[Capistrano][capistrano] installed (v2.5 or greater).

  [capistrano]: http://www.capify.org/

## Installation

Install the plugin

    ./script/plugin install git://github.com/mocoso/mysql_tasks.git

And add the following line to your deploy.rb file

    load 'vendor/plugins/mysql_tasks/lib/mysql_deploy'

Check everything has installed correctly with

    rake -T mysql && cap -T

Which should list your new rake and cap mysl tasks



Copyright (c) 2010 Joel Chippindale, released under the MIT license
