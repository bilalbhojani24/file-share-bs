class ApplicationController < ActionController::Base
    helper_method :current_user, :human_readable_size, :private_route

    def current_user 
        @current_user ||= User.find(session[:user]) if session[:user]
    end
    
    def private_route 
        redirect_to '/sign_in' unless current_user 
    end 

    def human_readable_size(size)
        @kilo = size / 1024
        if @kilo < 1024
            return "#{@kilo} KB"
        end
        @mega = @kilo / 1024
        if @mega < 1024
            return "#{@mega} MB"
        end
        @giga = @mb / 1024
        return "#{@giga} GB"
    end
end
