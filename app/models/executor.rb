class Executor < ApplicationRecord
    has_many :orders, dependent: :destroy

    validates :name, length: {minimum: 2}, presence: true
    validates :second_name, length: {minimum: 2}, presence: true
end
