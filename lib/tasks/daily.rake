namespace :daily do
  desc "TODO"
  task notify: :environment do
    num_new_user = User.today.count
    num_new_post = Micropost.today.count
    last_sign_in = User.before(Time.zone.now - 1.month, field: :last_sign_in_at).count
    notifier = Slack::Notifier.new "https://hooks.slack.com/services/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"
    notifier.ping "Daily notification
    - #{num_new_user} new user
    - #{num_new_post} new post
    - #{last_sign_in} user not login within a month
    "
  end
end
