class EpayFormParams
  attr_reader :url_ok, :url_cancel

  def initialize(params, return_url, cancel_url)
    @config = Spree::Gateway::EpayBg.where(type: 'Spree::Gateway::EpayBg', active: true).last.preferences
    @params = default_params.merge params
    @url_ok = return_url
    @url_cancel = cancel_url
  end

  def [](key)
    @params.fetch key
  end

  def encoded
    return @encoded if defined? @encoded
    @encoded = EpaySigner.encrypt @params
  end

  def checksum
    return @checksum if defined? @checksum
    @checksum = EpaySigner.checksum encoded, @config[:secret]#EpayConfig.secret
  end

  def post_url
    @config[:post_url]#'https://demo.epay.bg/'#EpayConfig.service_url
  end

  def page
    'credit_paydirect'#'paylogin'#'credit_paydirect'
  end

  def default_params
    {
      min: @config[:merchant_id],#EpayConfig.min,
      encoding: 'utf-8',
    }
  end
end
