class Spree::EpayController < Spree::StoreController
  def create
    @order = current_order
    ActiveRecord::Base.transaction do
      @order.payments.create!({
        amount: @order.total.to_f,
        payment_method: Spree::PaymentMethod.find_by(type: 'Spree::Gateway::EpayBg')
      })
      @order.next
    end

    @form_params = EpayFormParams.new({
      page: 'credit_paydirect',
      invoice: "#{@order.id}#{Time.now.to_i}",
      amount: @order.total.to_f,
      exp_date: (Time.now + 1.week).strftime('%d.%m.%Y'),
      currency: 'BGN',
    }, "#{Spree::Store.current.url}/orders/#{@order.number}", "#{Spree::Store.current.url}/order/#{@order.number}/epay/cancel")

    respond_to do |format|
      format.js
    end
  end

  def cancel_order
    @order = Spree::Order.find_by(number: params[:id])
    @payment = @order.payments.last
    @payment.send("void!") if @payment.payment_method.type == 'Spree::Gateway::EpayBg' && @payment.state == 'checkout'
    #TODO current order contents = @order OR order go back
    redirect_to '/cart'
  end
end
