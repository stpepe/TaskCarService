class OrderService < ApplicationRecord
  belongs_to :order
  belongs_to :service
end
