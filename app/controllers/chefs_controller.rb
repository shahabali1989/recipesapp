class ChefsController < ApplicationController

	def new
		@chef = Chef.new
	end

	def index
		@chefs = Chef.paginate(page: params[:page], per_page: 3)
	end

	def create
		@chef = Chef.new(chef_params)
		if @chef.save
			flash[:success] = "Account Created!"
			session[:chef_id] = @chef.id
			redirect_to recipes_path
		else
			render 'new'
		end
	end


	def edit
		@chef = Chef.find(params[:id])
		if !logged_in? || @chef != current_user
			flash[:danger] = "You can only edit your own profile. Login to continue"
			redirect_to recipes_path
		end
	end

	def update
		@chef = Chef.find(params[:id])
		if @chef == current_user && logged_in?	
			if @chef.update(chef_params)
				flash[:success] = "Account Updated"
				redirect_to recipes_path
			else
				render :edit
			end
		else
			flash[:danger] = "Please login to update your profile"
			redirect_to recipes_path
		end
	end

	def show
		@chef = Chef.find(params[:id])
		@recipes = @chef.recipes.paginate(page: params[:page], per_page: 3)
	end


	private
	def chef_params
		params.require(:chef).permit(:chefname, :email, :password)
	end


end
