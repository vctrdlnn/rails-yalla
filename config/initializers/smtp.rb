ActionMailer::Base.smtp_settings = {
  address: ENV['POSTMARK_SMTP_SERVER'],
  port: '25',
  domain: 'ya-la.heroku.com',
  user_name: ENV['POSTMARK_API_TOKEN'],
  password: ENV['POSTMARK_API_TOKEN'],
  authentication: :cram_md5,
  enable_starttls_auto: true
}
