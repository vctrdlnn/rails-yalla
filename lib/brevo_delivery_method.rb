require 'sib-api-v3-sdk'

class BrevoDeliveryMethod
  def initialize(settings)
    @settings = settings
  end

  def deliver!(mail)
    SibApiV3Sdk.configure do |config|
      config.api_key['api-key'] = ENV['BREVO_API_KEY']
    end

    api_instance = SibApiV3Sdk::TransactionalEmailsApi.new

    send_smtp_email = SibApiV3Sdk::SendSmtpEmail.new
    send_smtp_email.sender = { 'name' => extract_name(mail.from.first), 'email' => mail.from.first }
    send_smtp_email.to = mail.to.map { |email| { 'email' => email } }
    send_smtp_email.subject = mail.subject

    # Handle both HTML and plain text content
    if mail.html_part
      send_smtp_email.html_content = mail.html_part.body.to_s
    elsif mail.content_type&.include?('text/html')
      send_smtp_email.html_content = mail.body.to_s
    else
      send_smtp_email.text_content = mail.body.to_s
    end

    # Add reply_to if present
    if mail.reply_to.present?
      send_smtp_email.reply_to = { 'email' => mail.reply_to.first }
    end

    begin
      result = api_instance.send_transac_email(send_smtp_email)
      Rails.logger.info "[Brevo] Email sent successfully to #{mail.to.join(', ')} - Message ID: #{result.message_id}"
      result
    rescue SibApiV3Sdk::ApiError => e
      Rails.logger.error "[Brevo] Failed to send email to #{mail.to.join(', ')}: #{e.message}"
      Rails.logger.error "[Brevo] Response body: #{e.response_body}"
      raise
    end
  end

  private

  def extract_name(email)
    email.split('@').first.gsub(/[._]/, ' ').titleize
  end
end

ActionMailer::Base.add_delivery_method :brevo_api, BrevoDeliveryMethod
