class CommentsController < ApplicationController
  def create
    @course = Course.find(params[:course_id])
    @comment = @course.comments.build(comments_params)
    

    if @comment.save
      redirect_to @course, notice: "El comentario fue creado correctamente"
    else
      redirect_to @course, alert: "El comentario no ha podido ser creado"
    end 

  end

  private 
  def comments_params
    params.require(:comment).permit(:comment)
  end 
end
