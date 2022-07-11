class CategoriesController <ApplicationController
	before_action :require_admin, except: [:index, :show]

	def new
		@category = Category.new
	end
	
	def index
		@categories = Category.paginate(page: params[:page], per_page: 5)
	end


	def show
		@category = Category.find(params[:id])
		@articles = @category.articles.paginate(page: params[:page], per_page: 5)

	end

	def edit
		@category = Category.find(params[:id])
	end

	def update
		@category = Category.find(params[:id])
		if @category.update(params_category)
			flash[:notice] = "Category updates successfully"
			redirect_to @category
		else
			render 'edit'
		end
	end

	def create
		@category = Category.new(params_category)
		if @category.save
			flash[:notice] = "Category created successfully"
			redirect_to @category
		else
			render 'new'
		end
	end

	private

	def params_category
		params.require(:category).permit(:name)
	end

	def require_admin
		if !(logged_in? && current_user.admin?)
			flash["alert"] = "Only admins can perform that action"
			redirect_to categories_path
		end
	end

end
