class Spree::Gateway::EpayBg < Spree::Gateway
  preference :secret, :string
  preference :merchant_id, :string
  preference :post_url, :string

  def provider_class
    Spree::Gateway::EpayBg
  end

  def method_type
    'epay'
  end

  def auto_capture?
    false
  end

  def actions
    %w{capture void}
  end

  # Indicates whether its possible to capture the payment
  def can_capture?(payment)
    ['checkout', 'pending'].include?(payment.state)
  end

  # Indicates whether its possible to void the payment.
  def can_void?(payment)
    payment.state != 'void'
  end

  def capture(*)
    simulated_successful_billing_response
  end

  def cancel(*)
    simulated_successful_billing_response
  end

  def void(*)
    simulated_successful_billing_response
  end

  def source_required?
    false
  end

  def credit(*)
    simulated_successful_billing_response
  end

  private

  def simulated_successful_billing_response
    ActiveMerchant::Billing::Response.new(true, "", {}, {})
  end
end
