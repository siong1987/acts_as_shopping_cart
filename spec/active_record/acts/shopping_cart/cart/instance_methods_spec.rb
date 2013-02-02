require File.expand_path(File.dirname(__FILE__) + '../../../../../spec_helper')
# require 'spec_helper'

describe ActiveRecord::Acts::ShoppingCart::Cart::InstanceMethods do
  let(:klass) do
    klass = Class.new
    klass.send(:include, ActiveRecord::Acts::ShoppingCart::Cart::InstanceMethods)
  end

  let(:subject) do
    subject = klass.new
    subject.stub(:shopping_cart_items).and_return([])
    subject
  end

  let(:object) { stub }

  let(:shopping_cart_item) do
    stub(:status => 'sold', :save => true)
  end

  describe :add do
    context "item is not on cart" do
      before do
        subject.stub(:item_for).with(object)
      end

      it "creates a new shopping cart item" do
        subject.shopping_cart_items.should_receive(:create).with(:item => object, :price => 19.99, :status => 'sold')
        subject.add(object, 19.99, 'sold')
      end
    end

    context "item is already on cart" do
      before do
        subject.stub(:item_for).with(object).and_return(shopping_cart_item)
      end

      it "updates the quantity for the item" do
        shopping_cart_item.should_receive(:update_attributes).with(:price => 21.99, :status => 'borrowed')
        subject.add(object, 21.99, 'borrowed')
      end
    end
  end

  describe :clear do
    before do
      subject.shopping_cart_items.should_receive(:clear)
    end

    it "clears all the items in the cart" do
      subject.clear
      subject.empty?.should be_true
    end
  end

  describe "empty?" do
    context "cart has items" do
      before do
        subject.shopping_cart_items << mock
      end

      it "returns false" do
        subject.empty?.should be_false
      end
    end

    context "cart is empty" do
      it "returns true" do
        subject.empty?.should be_true
      end
    end
  end

  describe :remove do
    context "item is not on cart" do
      before do
        subject.stub(:item_for).with(object)
      end

      it "does nothing" do
        subject.remove(object)
      end
    end
  end

  describe :subtotal do
    context "cart has no items" do
      before do
        subject.stub(:shopping_cart_items).and_return([])
      end

      it "returns 0" do
        subject.subtotal.should eq(0)
      end
    end

    context "cart has items" do
      before do
        items = [stub(:price => 33.99), stub(:price => 45.99)]
        subject.stub(:shopping_cart_items).and_return(items)
      end

      it "returns the sum of the price * quantity for all items" do
        subject.subtotal.should eq(79.98)
      end
    end
  end

  describe :shipping_cost do
    it "returns 0" do
      subject.shipping_cost.should eq(0)
    end
  end

  describe :taxes do
    context "subtotal is 100" do
      before do
        subject.stub(:subtotal).and_return(100)
      end

      it "returns 8.25" do
        subject.taxes.should eq(8.25)
      end
    end
  end

  describe :tax_pct do
    it "returns 8.25" do
      subject.tax_pct.should eq(8.25)
    end
  end

  describe :total do
    before do
      subject.stub(:subtotal).and_return(10.99)
      subject.stub(:taxes).and_return(13.99)
      subject.stub(:shipping_cost).and_return(12.99)
    end

    it "returns subtotal + taxes + shipping_cost" do
      subject.total.should eq(37.97)
    end
  end
end
