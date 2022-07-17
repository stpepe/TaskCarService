class Order < ApplicationRecord
    belongs_to :executor
    has_many :order_services, dependent: :destroy
    has_many :services, through: :order_services

    validates :cost, presence: true

    scope :created_filter, ->(time) { where("created_at = ?", time) if time.present? }

    def calc_cost_create
        self.cost = calc_cost(self.services)
    end

    def calc_cost_update
        cost = calc_cost(self.services)
        self.update(:cost => cost)
    end

    def calc_cost(services)
        cost = 0
        services.each{
            |id| service = Service.find_by id: id
            cost += service.cost
        }
        return cost
    end

    def format_created_at
        self.created_at.strftime('%H:%M:%S %d-%m-%Y') 
    end
end
