class UsersController < ApplicationController
	before_action :set_user, only:[:show, :edit, :update, :destroy]
	before_action :require_user, only: [:edit, :update]
	before_action :require_same_user, only: [:edit, :update, :destroy]
		

	def new
		@user = User.new	
	end

	def index
		@users = User.paginate(page: params[:page], per_page: 5)
	end

	def show
		@articles = @user.articles
	end

	def edit
	end

	def update
		if @user.update(params_user)
			flash[:notice] = "Your account information is successfully updated"
			redirect_to @user
		else
			render 'edit'
		end
	end

	def create
		@user = User.new(params_user)
		if @user.save
			flash[:notice] = "Welcome to Alpha Blog #{@user.class}, you have successfully signed up"
			redirect_to articles_path
		else
			render 'new'
		end
	end

	def destroy
		@user.destroy
		session[:user_id] = nil if @user == current_user
		flash[:notice] = "Account and all associated articles successfully deleted"
		redirect_to articles_path
	end

	private

	def params_user
		params.require(:user).permit(:username, :email, :password)
	end

	def set_user
		@user = User.find(params[:id])
	end

	def require_same_user
    if current_user != @user && !current_user.admin?
      flash[:alert] = "You can only edit your own account"
      redirect_to @user
    end
	end
end