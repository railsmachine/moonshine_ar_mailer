God.watch do |w|
  w.name = "ar_sendmail"
  #w.uid = UID
  #w.gid = GID
  w.interval = 30.seconds # default
  w.start = "/sbin/service ar_sendmail start"
  w.stop = "/sbin/service ar_sendmail stop"
  w.restart = "/sbin/service ar_sendmail restart"
  w.start_grace = 10.seconds
  w.restart_grace = 10.seconds
  w.pid_file = '/var/run/ar_sendmail.pid'

  w.behavior(:clean_pid_file)

  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 5.seconds
      c.running = false
    end
  end
end
