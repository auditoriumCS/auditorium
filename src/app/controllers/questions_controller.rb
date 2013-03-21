class QuestionsController < ApplicationController

	def index
		@questions = Post.where(post_type: 'question')

		respond_to do |format|
			format.html  # index.html.erb
			format.json  { render :json => @questions }
		end
	end

	def show
		@question = Post.where(id: params[:id])

		respond_to do |format|
			format.html  # show.html.erb
			format.json  { render :json => @question }
		end
	end

	def new
		@question = Post.new(post_type: 'question')

		respond_to do |format|
			format.html  # new.html.erb
			format.json  { render :json => @question }
		end
	end

	def create
		@question = Post.new(params[:post])

		respond_to do |format|
			if @question.save
				format.html { redirect_to @question, success: t('question.create.success') }
				format.json { render json: @question, status: :created, location: @question }
			else
				format.html { render action: 'new' }
				format.json { render json: @question.errors, status: :unprocessable_entity }
			end
		end
	end

	def update
		@question = Post.find(params[:id])

		respond_to do |format|
			if @question.update_attributes(params[:post])
				format.html { redirect_to @question, success: t('question.update.success') }
				format.json { head :no_content }
			else
				format.html { render action: 'edit' }
				format.json { render json: @question.errors, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		@question = Post.find(params[:id])
		@question.destroy
		
		respond_to do |format|
			format.html { redirect_to questions_url }
			format.json { head :no_content }
		end
	end
end
