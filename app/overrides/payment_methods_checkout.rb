Deface::Override.new(virtual_path: "spree/checkout/_payment",
                     name: "payment_methods_checkout",
                     replace: "ul#payment-method-fields",
                     text:
                      '
                      <% @order.available_payment_methods.each do |method| %>
                        <li class="list-group-item">
                          <label>
                            <% if method.type == "Spree::Gateway::EpayBg" %>
                              <%= radio_button_tag "order[payments_attributes][][payment_method_id]", method.id, method == @order.available_payment_methods.first, class: "epaybg_method pm_method" %>
                              <%= Spree.t(method.name, scope: :payment_methods, default: method.name) %>
                            <% else %>
                              <%= radio_button_tag "order[payments_attributes][][payment_method_id]", method.id, method == @order.available_payment_methods.first, class: "pm_method" %>
                              <%= Spree.t(method.name, scope: :payment_methods, default: method.name) %>
                            <% end %>
                          </label>
                        </li>
                      <% end %>
                      ')

Deface::Override.new(virtual_path: "spree/checkout/_payment",
                     name: "epay_payment_method_js",
                     insert_after: "div#payment",
                     text:
                     '
                     <script>
                         var buttonName = $("input.btn.btn-lg.btn-success").val();
                         if($(".epaybg_method.pm_method").is(":checked")){
                           var linkName = $(".epay_link").text();
                           $(".btn.btn-lg.btn-success").replaceWith("<a class=\'epay_button_checkout btn btn-lg btn-success\' data-remote=\'true\' rel=\'nofollow\' data-method=\'post\' href=\'/order/checkout/epay\' style=\'border-radius: 0;\'>"+ linkName + "</a>");
                         }
                         $(".pm_method").change(function() {
                           if($(".epaybg_method.pm_method").is(":checked")){
                             var linkName = $(".epay_link").text();
                             $(".btn.btn-lg.btn-success").replaceWith("<a class=\'epay_button_checkout btn btn-lg btn-success\' data-remote=\'true\' rel=\'nofollow\' data-method=\'post\' href=\'/order/checkout/epay\' style=\'border-radius: 0;\'>"+ linkName + "</a>");
                           } else {
                             $(".epay_button_checkout").replaceWith("<input name=\'commit\' value=\'" + buttonName + "\' class=\'btn btn-lg btn-success\' type=\'submit\'>");
                           }
                         });
                     </script>
                     ')
