module ActiveRecord
  module Acts
    module ShoppingCart
      module Cart
        module InstanceMethods
          #
          # Adds a product to the cart
          #
          def add(object, price, status)
            cart_item = item_for(object)

            unless cart_item
              shopping_cart_items.create(:item => object, :price => price, :status => status)
            else
              cart_item.update_attributes(:price => price, :status => status)
            end
          end

          #
          # Deletes all shopping_cart_items in the shopping_cart
          #
          def clear
            shopping_cart_items.clear
          end

          #
          # Returns true when the cart is empty
          #
          def empty?
            shopping_cart_items.empty?
          end

          #
          # Remove an item from the cart
          #
          def remove(object)
            if cart_item = item_for(object)
              if cart_item
                cart_item.delete
              end
            end
          end

          #
          # Returns the subtotal by summing the price for all the items in the cart
          #
          def subtotal
            ("%.2f" % shopping_cart_items.inject(0) { |sum, item| sum += (item.price) }).to_f
          end

          def shipping_cost
            0
          end

          def taxes
            subtotal * self.tax_pct * 0.01
          end

          def tax_pct
            8.25
          end

          #
          # Returns the total by summing the subtotal, taxes and shipping_cost
          #
          def total
            ("%.2f" % (self.subtotal + self.taxes + self.shipping_cost)).to_f
          end
        end
      end
    end
  end
end
