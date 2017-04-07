Spree::Core::Engine.routes.draw do
  post '/epay/capture' => 'epay_notifications#create'
  post 'order/checkout/epay' => 'epay#create'
  get 'order/:id/epay/cancel' => 'epay#cancel_order'
end
