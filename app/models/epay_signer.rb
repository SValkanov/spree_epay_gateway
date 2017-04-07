module EpaySigner
  def self.encrypt(params_hash)
    data = <<-DATA
    MIN=#{params_hash[:min]}
    INVOICE=#{params_hash[:invoice]}
    AMOUNT=#{params_hash[:amount]}
    CURRENCY=#{params_hash[:currency]}
    EXP_TIME=#{params_hash[:exp_date]}
    DESCR=#{params_hash[:descr]}
    ENCODING=#{params_hash[:encoding]}
    DATA

    Base64.strict_encode64 data
  end

  def self.checksum(encrypted, key)
    OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('sha1'), key, encrypted)
  end
end
