class SubTasksController < ApplicationController
  def create
    @todo = Todo.find(params[:todo_id])
    @sub_task = SubTask.new(sub_task_params)
    @sub_task.todo = @todo
    @sub_task.save
  end

  private

  def sub_task_params
    params.require(:sub_task).permit(:title)
  end

end
