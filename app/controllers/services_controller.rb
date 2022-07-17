class ServicesController < ApplicationController
    before_action :find_category, only: [:edit, :update, :destroy]
    before_action :fetch_categories, only: [:new, :edit]
    
    def index
        @services = Service.all.order(category_id: :asc, name: :asc)
    end

    def new
        @service = Service.new
    end

    def create
        @service = Service.new(service_params)
        if @service.save
            redirect_back(fallback_location: root_path)
            flash[:success] = "Услуга добавлена!"
        else
            redirect_back(fallback_location: root_path)
            flash[:warning] = "Услуга не добавлена!"
        end
    end

    def edit
    end

    def update
        if @service.update service_params
            redirect_to(services_path)
            flash[:success] = "Услуга изменена"
        else
            redirect_to(request.referrer || root_path)
            flash[:warning] = "Не удалось изменить услугу"
        end    
    end

    def destroy
        @service.destroy
        redirect_to(services_path)
        flash[:success] = "Услуга удалена"
    end

    private
    def service_params
        params.require(:service).permit(:name, :category_id, :cost)
    end

    def find_category
        @service = Service.find params[:id]  
    end

    def fetch_categories
        @categories = Category.all
    end
end
