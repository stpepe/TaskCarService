class CategoriesController < ApplicationController
    before_action :find_category, only: [:edit, :update, :destroy]

    def index
        @categories = Category.all.order(name: :asc)
    end
    
    def new
        @category = Category.new
    end

    def create
        @category = Category.new category_params
        if @category.save
            redirect_to(categories_path)
            flash[:success]="Категория добавлена!"
        else
            redirect_to(request.referrer || root_path)
            flash[:warning]="Не удалось добавить категорию!"
        end
    end
    
    def edit
    end

    def update
        if @category.update category_params
            redirect_to(categories_path)
            flash[:success] = "Категория изменена"
        else
            redirect_to(request.referrer || root_path)
            flash[:warning] = "Не удалось изменить категорию"
        end    
    end

    def destroy
        @category.destroy
        redirect_to(categories_path)
        flash[:success] = "Категория удалена"
    end

    private

        def category_params
            params.require(:category).permit(:name)
        end

        def find_category
            @category = Category.find params[:id]  
        end
end
