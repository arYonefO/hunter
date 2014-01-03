namespace :db do
  desc "Poll instagram for appropriate data"
  task populate: :environment do
    # Entry.chase_tag('rsa_graffiti')
    # Entry.chase_tag('bayareagraffiti')
    # Entry.chase_user('nemans')
    # Entry.chase_tag('melbournegraffiti')
    # Entry.chase_tag('nexus_streetart')
    # Entry.chase_tag('preciousgraffiti')
    Entry.clean_them_out('gabriels_twin')
  end

  desc "Update the proximity of entries"
  task prox: :environment do
    Entry.prox_the_entries
  end
end