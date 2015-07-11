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

  def pay
    @course = Course.find(params[:id])
    @payment = Payment.new
    @payment.order_id = SecureRandom.random_number(10).to_s
    
    @payment.session_id = SecureRandom.random_number(10).to_s
    @payment.amount = @course.price
    @payment.status = false
    @payment.save

    @tbk_url_cgi = "http://186.64.122.15/cgi-bin/kcc_Mcfly/tbk_bp_pago.cgi"
    @tbk_tipo_transaccion = "TR_NORMAL"
    @tbk_url_exito = "http://google.cl"
    @tbk_url_fracaso = "http://yahoo.es"
  end

  def confirmation
    payment = Payment.where(order_id: params["TBK_ORDEN_COMPRA"]).where(session_id: params["TBK_ID_SESION"]).first
    rejected = false
    rejected = true if payment.nil?
    rejected = true if payment.amount.to_s + "00" != params[:TBK_MONTO] 
    rejected = true if params.has_key?(:TBK_RESPUESTA) || !params.has_key?(:TBK_ORDEN_COMPRA) || !params.has_key?(:TBK_TIPO_TRANSACCION) || !params.has_key?(:TBK_MONTO) || !params.has_key?(:TBK_CODIGO_AUTORIZACION) || !params.has_key?(:TBK_FECHA_CONTABLE) || !params.has_key?(:TBK_HORA_TRANSACCION) || !params.has_key?(:TBK_ID_SESION) || !params.has_key?(:TBK_ID_TRANSACCION) || !params.has_key?(:TBK_TIPO_PAGO) || !params.has_key?(:TBK_NUMERO_CUOTAS) || !params.has_key?(:TBK_VCI) || !params.has_key?(:TBK_MAC)
    rejected = true if payment.status

    payment.status = true 
    payment.payment_type = params[:TBK_TIPO_PAGO]
  
    if rejected
      render text: "RECHAZADO"
    else
        if params[:TBK_RESPUESTA] == "0"
          payment.card_last_numbers = params[:TBK_FINAL_NUMERO_TARJETA]
          payment.authorization = params[:TBK_CODIGO_AUTORIZACION]
        end 
      render text: "ACEPTADO"
    end 
    payment.save
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
