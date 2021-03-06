class RecipesController < ApplicationController

def index
	@recipes = Recipe.paginate(page: params[:page], per_page: 2)
	respond_to do |format|
		format.html
		format.json { render json: @recipes}
	end
end

def show
	@recipe = Recipe.find(params[:id])
	@chef = @recipe.chef
	respond_to do |format|
		format.html
		format.json { render json: @recipe }
	end
end

def new
	@recipe = Recipe.new
	if !logged_in?
		redirect_to recipes_path
		flash[:warning] = "Log in to create a recipe"
	end
end

def create
	@recipe = Recipe.new(recipe_params)
	@recipe.chef = current_user
	if logged_in?
		if @recipe.save
			flash[:success] = "Your recipe was saved!"
			redirect_to recipes_path
		else	
			render :new
		end
	else
		flash[:danger] = "You need to login to create a recipe"
		redirect_to recipes_path
	end
end

def edit
		@recipe = Recipe.find(params[:id])
	if !logged_in? || @recipe.chef != current_user
		flash[:danger] = "You are not allowed to edit this recipe"
		redirect_to recipe_path(@recipe)
	end
end

def update
	@recipe = Recipe.find(params[:id])
	if logged_in? && @recipe.chef == current_user
		if @recipe.update(recipe_params)
			flash[:success] = "Your recipe was updated successfully"
			redirect_to recipe_path(@recipe)
		else
			render :edit
		end
	else
		flash[:danger] = "Could not update recipe. Please login"
		redirect_to recipe_path(@recipe)
	end
end

def like
	if logged_in?	
		@recipe = Recipe.find(params[:id])
		newlike = Like.create(like: params[:like], chef: current_user, recipe: @recipe)
		if newlike.valid?
			if (newlike.like == true)
				flash[:success] = "You liked this recipe!"
			else
				flash[:success] = "You disliked this recipe!"
			end
		else
			flash[:danger] = "You can only like/dislike a recipe once"
		end
	else
		flash[:danger] = "You need to login to like a recipe"
	end
		redirect_to :back

end

private 

	def recipe_params
		params.require(:recipe).permit(:name, :summary, :description, :picture)
	end

end