ActiveAdmin.register Users do


  show do

  end


  controller do



    def create
      @user = User.new(permitted_params[:user])
    end

  end

end