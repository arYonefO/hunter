namespace :db do
  desc "Poll instagram for appropriate data"
  task populate: :environment do
    Entry.chase_tag('rsa_graffiti')
    Entry.chase_tag('DSB_graff')
    Entry.chase_user('nemans')
    Entry.chase_tag('стритарт')
    Entry.chase_tag('arteurbano')
    Entry.chase_tag('gatekunst')
    Entry.chase_tag('artederua')
  end

  desc "hoover the selected user"
  task hoover_user: :environment do
    Entry.clean_them_out('capetownstreetart')
  end

  desc "Update the proximity of entries"
  task prox: :environment do
    Entry.prox_the_entries
  end

  desc "Update the response_objects of entries"
  task resp_obj: :environment do
    Entry.serialize_the_entries
  end

  desc "hoover the selected tag"
  task hoover_tag: :environment do
    Entry.hoover_tag("ストリートアート")
  end
end

namespace :cache do
  desc "Load the feed into the cache"
  task load: :environment do
    SearchTerm.all.each do |locale|
      Entry.prepare_for_launch(locale.lat, locale.lng) if locale
    end
  end
end

['etamcru', 'sztukaulicy', 'etamcrew', 'saineretam', 'katowicestreetart',
  'streetartinpoland', 'streetart_bakkem', 'gatekunst', 'capetownstreetart',
  'стритарт', 'istanbulstreetart', 'streetartbogota','bogotastreetart',
  'bristolstreetart', 'santiagostreetart', 'buenosairesstreetart',
  'streetartbuenosaires', 'streetartlisbon', 'lisbonstreetart', 'abyss607',
  'canberragraff',"ストリートアート"
]