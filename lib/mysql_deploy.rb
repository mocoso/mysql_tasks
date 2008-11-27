# MySQL Capistrano tasks
#
# Include in your deploy recipes by adding
#
#   load 'vendor/plugins/mysql_tasks/lib/mysql_deploy
#
# To your deploy.rb file
namespace :mysql do
  desc 'Dumps the production database to db/production_data.sql on the remote server'
  task :dump, :roles => :db, :only => { :primary => true } do
    run "cd #{deploy_to}/#{current_dir} && " +
      "rake RAILS_ENV=#{rails_env} mysql:dump --trace"
  end

  desc 'Downloads db/production_data.sql from the remote production environment to your local machine'
  task :download_dump, :roles => :db, :only => { :primary => true } do
    download "#{deploy_to}/#{current_dir}/tmp/production_data.sql.gz", "tmp/production_data.sql.gz"
  end

  desc 'Cleans up data dump file'
  task :cleanup_dump, :roles => :db, :only => { :primary => true } do
    run "rm #{deploy_to}/#{current_dir}/tmp/production_data.sql.gz"
  end

  desc 'Dumps, downloads and then cleans up the production data dump'
  task :db_runner do
    dump
    download_dump
    cleanup_dump
  end
end