module ActiveRecord
  module Acts
    module ShoppingCartItem
      module InstanceMethods
        #
        # Returns the subtotal, multiplying the quantity times the price of the item.
        #
        def subtotal
          ("%.2f" % (self.price)).to_f
        end

        #
        # Updates the price of the item
        #
        def update_price(new_price)
            self.price = new_price
            self.save
        end
      end
    end
  end
end
