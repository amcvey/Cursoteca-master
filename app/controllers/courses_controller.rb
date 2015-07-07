class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index]
  load_and_authorize_resource
  # GET /courses
  # GET /courses.json
 def index
    @query = params[:q]
    if @query.nil?
      @courses = Course.all
    else
      @courses = Course.where("title like ? or place like ?", "%#{@query}%", "%#{@query}%")
    end

      @courses = @courses.page params[:page]
      respond_to do |f|
        f.html
        f.json
        f.js
      end
  end
 

  def add_to_wishlist 
      @courses = Course.all
      @course = Course.find(params[:id])
      @wishlist =@course.wishlists.build(user: current_user)

    if @wishlist.save
      flash[:notice] = "El Curso ha sido agregado con éxito a tu wishlist"

     else
      flash[:alert] = "El Curso No ha sido agregado con éxito a tu wishlist"
    end 
  end


  # GET /courses/1
  # GET /courses/1.json
  def show

    @comment = @course.comments.build
    @last_comments =@course.comments.last(5)
    @courses = Course.all
    @hash = Gmaps4rails.build_markers(@courses) do |course, marker|
    marker.lat course.latitude
    marker.lng course.longitude
end

  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
  end



  # POST /courses
  # POST /courses.json
  def create
    @course = Course.new(course_params)
    @course.user = current_user

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1
  # PATCH/PUT /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course.destroy
    respond_to do |format|
      format.html { redirect_to courses_url, notice: 'Course was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.friendly.find(params[:id])
    end
    
    
    

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.require(:course).permit(:photo, :title, :place, :description, :punctuation, :price, :category, :address, :longitude, :latitude)
    end
end
