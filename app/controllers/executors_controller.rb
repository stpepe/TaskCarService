class ExecutorsController < ApplicationController
    before_action :find_executor, only: [:edit, :update, :destroy]

    def index
        @executors = Executor.all.order(name: :asc, second_name: :asc)
    end

    def sort 
        
        index(sort_params)
    end
    
    def new
        @executor = Executor.new
    end

    def create
        @executor = Executor.new executor_params
        if @executor.save
            redirect_to(executors_path)
            flash[:success]="Исполнитель добавлен!"
        else
            redirect_to(request.referrer || root_path)
            flash[:warning]="Не удалось добавить исполнителя!"
        end
    end
    
    def edit
    end

    def update
        if @executor.update executor_params
            redirect_to(executors_path)
            flash[:success] = "Исполнитель отредактирован"
        else
            redirect_to(request.referrer || root_path)
            flash[:warning] = "Не удалось отредактировать исполнителя"
        end    
    end

    def destroy
        @executor.destroy
        redirect_to(categories_path)
        flash[:success] = "Исполнитель удален"
    end

    private

        def executor_params
            params.require(:executor).permit(:name, :second_name)
        end

        def find_executor
            @executor = Executor.find params[:id]  
        end
end
