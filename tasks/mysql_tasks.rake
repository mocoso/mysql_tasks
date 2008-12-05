# Based on http://errtheblog.com/posts/31-rake-around-the-rosie
require 'yaml'

namespace :mysql do

  desc "Launch mysql shell."
  task :console do
    system sh_mysql(database_config)
  end

  desc "Dump the current database to a gzipped MySQL file"
  task :dump => :environment do
    file_path = File.join('tmp', "#{RAILS_ENV}_data.sql.gz")
    `#{sh_mysqldump(database_config)} | gzip > #{file_path}`
  end

  desc "Refreshes your local development environment to the current production database"
  task :refresh_from_production do
    require_environment('development')
    `cap mysql:db_runner`
    `rake mysql:unzip_production_dump mysql:load_from_production_dump --trace`
  end

  desc "Unzips production data downloaded to your tmp directory"
  task :unzip_production_dump do
    `gunzip tmp/production_data.sql.gz`
  end

  desc "Loads the production data downloaded into tmp/production_data.sql into your local development database"
  task :load_from_production_dump do
    require_environment('development')
    `#{sh_mysql(database_config)} < tmp/production_data.sql`
  end

  def require_environment(env)
    unless RAILS_ENV == env
      raise "Can only run this in dev environment"
    end
  end

  def database_config
    config = YAML.load(open(File.join('config', 'database.yml')))[RAILS_ENV]
    unless config["adapter"] == 'mysql'
      raise "Task not supported by '#{config["adapter"]}'"
    end
    config
  end

  def connection_options(config)
    options = ''
    options << " -u #{config['username']}" if config['username']
    options << " -p#{config['password']}"  if config['password']
    options << " -h #{config['host']}"     if config['host']
    options << " -P #{config['port']}"     if config['port']
    options << " #{config['database']}"    if config['database']
    options
  end

  def sh_mysql(config)
    "mysql#{connection_options(config)}"
  end

  def sh_mysqldump(config)
    "mysqldump#{connection_options(config)}"
  end

end
