namespace :email do
  desc "Test Brevo email sending via API"
  task :test, [:recipient] => :environment do |t, args|
    recipient = args[:recipient] || 'test@example.com'

    puts "Testing Brevo API email delivery to: #{recipient}"
    puts "API Key present: #{ENV['BREVO_API_KEY'].present?}"
    puts ""

    require 'sib-api-v3-sdk'

    SibApiV3Sdk.configure do |config|
      config.api_key['api-key'] = ENV['BREVO_API_KEY']
    end

    api_instance = SibApiV3Sdk::TransactionalEmailsApi.new

    send_smtp_email = SibApiV3Sdk::SendSmtpEmail.new
    send_smtp_email.sender = { 'name' => 'Yala', 'email' => 'contact@justyalla.app' }
    send_smtp_email.to = [{ 'email' => recipient }]
    send_smtp_email.subject = 'Test email from Yala App'
    send_smtp_email.html_content = "<html><body><h1>Test Email</h1><p>This is a test email sent at #{Time.now}</p><p>If you received this, Brevo API is working correctly!</p></body></html>"

    result = api_instance.send_transac_email(send_smtp_email)
    puts "Email sent successfully!"
    puts "Message ID: #{result.message_id}"
  rescue SibApiV3Sdk::ApiError => e
    puts "Brevo API Error: #{e.message}"
    puts "Response body: #{e.response_body}"
  rescue => e
    puts "Error: #{e.message}"
    puts e.backtrace.first(5).join("\n")
  end
end
