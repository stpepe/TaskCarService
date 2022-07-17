class OrdersController < ApplicationController
    before_action :fetch_services, only: [:new, :edit, :index]
    before_action :fetch_executors, only: [:new, :edit, :index]
    before_action :fetch_categories, only: [:index]
    before_action :find_order, only: [:edit, :update, :destroy]

    

    def index 
        if request.get?
            
            respond_to do |format|
                format.html {@orders = Order.all}
                format.xlsx {respond_xlsx()}
            end    
        elsif request.post?
            @orders = filter()
            @orders = sort(@orders)
            session[:orders] = @orders
            respond_to do |format| 
               format.turbo_stream 
            end    
        end
    end

    def new
        @order = Order.new
    end

    def create
        @order = Order.new(order_params)
        @order.calc_cost_create
        if @order.save
            redirect_to(orders_path)
            flash[:success] = "Заказ успешно создан!"
        else
            redirect_to(orders_path)
            flash[:warning] = "Заказ не был создан!"
        end
    end
    
    def edit
        respond_to do |format| 
            format.html
            format.turbo_stream 
        end 
    end

    def update
        OrderService.where("order_id = #{@order.id}").destroy_all
        if @order.update order_params
            @order.calc_cost_update
            redirect_to(orders_path)
            flash[:success] = "Заказ успешно изменен!"
        else
            redirect_to(orders_path)
            flash[:warning] = "Заказ не был изменен!"
        end
    end

    def destroy
        OrderService.where("order_id = #{@order.id}").destroy_all
        @order.destroy
        respond_to do |format|
            format.html{
                redirect_to(orders_path)
                flash[:success] = "Заказ удален"
            }
            format.turbo_stream
        end    
    end

    private

    def order_params
        params.require(:order).permit(:executor_id, service_ids:[])
    end

    def fetch_services
        @services = Service.all.order(name: :asc)
    end

    def fetch_executors
        @executors = Executor.all.order(second_name: :asc)
    end

    def fetch_categories
        @categories = Category.all.order(name: :asc)
    end

    def find_order
        @order = Order.find params[:id]  
    end

    def fetch_filters
        filt_serv = []
        if params[:service][:service_ids].length != 1
            params[:service].each{|key, value| filt_serv.append(value)}
        else
            Service.select(:id).all.each{|value| filt_serv.append(value)}
        end
        filt_categ = []
        if params[:category][:category_ids].length != 1
            params[:category].each{|key, value| filt_categ.append(value)}
        else
            Category.select(:id).all.each{|value| filt_categ.append(value)}
        end
        filt_exe = []
        if params[:executor][:executor_ids].length != 1
            params[:executor].each{|key, value| filt_exe.append(value)}
        else
            Executor.select(:id).all.each{|value| filt_exe.append(value)}
        end
        return [filt_serv, filt_categ, filt_exe]
    end

    def filter
        filters = fetch_filters()

            @orders = Order.all.where(:executor_id => filters[2])
            .where(:id => OrderService.select(:order_id)
                .where(:service_id => Service.select(:id)
                    .where(:id => filters[0])
                    .where(:category_id => Category.select(:id)
                        .where(:id => filters[1])
                    )
                )
            )
            if params[:created_at] != "" 
                @orders = @orders.all.where("'#{params[:created_at]} 00:00:00' < created_at ").where("'#{params[:created_at]} 23:59:59' > created_at")
            else     
                return @orders 
            end
    end

    def sort(orders)
        if params[:cost_sort] != "" && params[:date_sort] != ""
            orders.order(cost: :"#{params[:cost_sort]}").order(created_at: :"#{params[:date_sort]}")
        elsif params[:cost_sort] != "" 
            orders.order(cost: :"#{params[:cost_sort]}")
        elsif params[:date_sort] != ""
            orders.order(created_at: :"#{params[:date_sort]}")
        else
            orders
        end
        # Согласен, странно написан метод, но удивительно то, что иначе он не работает
        # А может я не совсем понимаю, как работает экземпляр @orders и плохо пишу код
    end

    def respond_xlsx()
        @orders = Array.new
        @executors = Array.new
        @services = Array.new
        @categories = Array.new
        session[:orders].each{|order| 
            order = Order.find_by id: order["id"]
            @orders.append(order)
            @executors.append(order.executor)
            tmp_s = order.services
            tmp_c = Array.new
            tmp_s.each{|service| 
                order.services.each{|service| tmp_c.append(service.category)}
            }
            @services.append(tmp_s)
            @categories.append(tmp_c)
        }
        xlsx_doc = render_to_string(
                            layout: false, handlers: [:axlsx], formats: [:xlsx],
                            template: "orders/index",
                            locals: {orders: @orders, 
                                executors: @executors,
                                services: @services,
                                categories: @categories
                            }
                        )               
        send_data xlsx_doc, filename: "orders_table_#{Time.now}.xls"
    end
end
