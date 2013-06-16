task :env do
  require "#{File.dirname(__FILE__)}/DataModel.rb"
end

namespace :db do
  desc 'Recreate the database'
  task :recreate => %w(env) do
    DataMapper.auto_migrate!
  end
  
  desc 'Upgrade the database'
  task :upgrade => %w(env) do
    DataMapper.auto_upgrade!
  end
end
