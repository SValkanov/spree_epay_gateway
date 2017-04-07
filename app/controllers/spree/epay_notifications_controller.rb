class Spree::EpayNotificationsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def create
    config = Spree::Gateway::EpayBg.where(type: 'Spree::Gateway::EpayBg', active: true).last.preferences
    encoded, checksum = params[:encoded], params[:checksum]

    if (OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('sha1'), config[:secret], encoded) == checksum)
      details = Base64.decode64(encoded).strip
      invoice, status = details.split(':')

      order = Spree::Order.where(id: invoice.split('=').last.to_s[0...-10]).first
      payment = order.payments.last
      #epay_order.notifications.create! encoded: encoded, checksum: checksum, details: details

      if status == 'STATUS=PAID'
        ActiveRecord::Base.transaction do
          payment.send("capture!") if payment.payment_method.type == 'Spree::Gateway::EpayBg' && payment.state == 'checkout'
        end

        render text: "#{invoice}:STATUS=OK"
        return
      elsif status == 'STATUS=DENIED' or status == 'STATUS=EXPIRED'
        payment.send("void!") if payment.payment_method.type == 'Spree::Gateway::EpayBg' && payment.state == 'checkout'

        render text: "#{invoice}:STATUS=OK"
        return
      end
    else
      render text: "#{invoice}:STATUS=ERR"
      return
    end

    render nothing: true
  end
end
