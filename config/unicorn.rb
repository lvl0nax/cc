pid_file   = "/var/www/vhosts/rails/centercareer.ru/tmp/pids/unicorn.pid"
old_pid    = pid_file + '.oldbin'

timeout 30
worker_processes 4
listen "/var/www/vhosts/rails/centercareer.ru/tmp/sockets/unicorn.sock", :backlog => 1024
pid "/var/www/vhosts/rails/centercareer.ru/tmp/pids/unicorn.pid"
stderr_path "/var/www/vhosts/rails/centercareer.ru/public_html/log/unicorn.stderr.log"
stdout_path "/var/www/vhosts/rails/centercareer.ru/public_html/log/unicorn.stdout.log"

preload_app true

GC.copy_on_write_friendly = true if GC.respond_to?(:copy_on_write_friendly=)

before_exec do |server|
  ENV["BUNDLE_GEMFILE"] = "/var/www/vhosts/rails/centercareer.ru/public_html/Gemfile"
end

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
  ActiveRecord::Base.connection.disconnect!

  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and
  ActiveRecord::Base.establish_connection
end


