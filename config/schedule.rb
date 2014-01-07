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

every 57.minutes do
  runner "Entry.hoover_tag('rsa_graffiti')", :environment => 'development'
end

every 2.hours do
  runner "Entry.hoover_tag('bayareagraffiti')", :environment => 'development'
end

every 3.hours do
  runner "Entry.hoover_tag('streetartutopia')", :environment => 'development'
end

every 5.hours do
  runner "Entry.hoover_tag('artecallejero')", :environment => 'development'
end