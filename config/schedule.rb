# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

every 15.minute do
   runner "Entry.chase_tag('rsa_graffiti')", :environment => 'development'
end

every 19.minute do
   runner "Entry.chase_tag('preciousgraffiti')", :environment => 'development'
end

every 32.minutes do
  runner "Entry.chase_tag('nexus_streetart')", :environment => 'development'
end

every 43.minutes do
  runner "Entry.chase_tag('bayareagraffiti')", :environment => 'development'
end

every 47.minutes do
  runner "Entry.chase_tag('melbournegraffiti')", :environment => 'development'
end


