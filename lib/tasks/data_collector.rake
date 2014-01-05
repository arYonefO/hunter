namespace :db do
  desc "Poll instagram for appropriate data"
  task populate: :environment do
    Entry.chase_tag('rsa_graffiti')
    Entry.chase_tag('bayareagraffiti')
    Entry.chase_user('nemans')
    Entry.chase_tag('melbournegraffiti')
    Entry.chase_tag('nexus_streetart')
    Entry.chase_tag('preciousgraffiti')
  end

  desc "hoover the selected user"
  task hoover_user: :environment do
    Entry.clean_them_out('gabriels_twin')
  end

  desc "Update the proximity of entries"
  task prox: :environment do
    Entry.prox_the_entries
  end

  desc "hoover the selected tag"
  task hoover_tag: :environment do
    Entry.hoover_tag('melbournegraffiti')
  end
end