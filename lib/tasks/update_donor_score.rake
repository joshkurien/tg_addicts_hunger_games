namespace :update do
  desc 'One Time rake task to update missed donor score levels'
  task donor_score: :environment do
    UnknownUserRecord.find_each do |record|
      next unless record.name.match(/\ [🥇🥈🥉💎]+$/)
      name = record.name.sub(/\ [🥇🥈🥉💎]+$/,'')
      record.update(name: name)
    end

    User.find_each do |user|
      UnknownUserRecord.update_unknown(user.full_name,user.id)
    end
  end
end

