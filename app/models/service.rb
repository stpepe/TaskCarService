class Service < ApplicationRecord
    belongs_to :category
    has_many :order_services, dependent: :destroy
    has_many :orders, through: :order_services

    validates :name, presence: true
    validates :cost, presence: true
end
