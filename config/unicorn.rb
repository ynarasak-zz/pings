timeout 15
preload_app true

worker_processes 3

# whatever you had in your unicorn.rb file
@sidekiq_pid = nil

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  #defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!

  if Rails.env.production?
    #@sidekiq_pid ||= spawn("bundle exec sidekiq -c 2")
    @sidekiq_pid ||= spawn("bundle exec sidekiq -C config/sidekiq.yml")
    Rails.logger.info('Spawned sidekiq #{@sidekiq_pid}')
  end
end 


after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  #defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
