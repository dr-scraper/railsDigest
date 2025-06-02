namespace :mailer do
  desc "Send daily chapter email"
  task send_daily: :environment do
    User.find_each do |user|
      DigestMailer.daily_chapter(user).deliver_now
    end
  end
end