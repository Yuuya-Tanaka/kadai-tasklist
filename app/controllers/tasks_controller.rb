class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
   before_action :require_user_logged_in, only: [:index, :show]
  
  def index
    if logged_in?
      @task = current_user.tasks.build
      @pagy, @tasks = pagy(Task.order(id: :desc), items: 3)
    end  
  end

  def show
  end

  def new
    @task = Task.new
  end

  def create
     @task = current_user.tasks.build(task_params)
    
    if @task.save
      flash[:success] = 'タスクが投稿されました'
      redirect_to @task
    else
      @pagy, @tasks = pagy(current_user.tasks.order(id: :desc))
      flash[:danger] = 'タスクが投稿されません'
      render :new
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:success] = 'タスクが編集されました'
      redirect_to @task
    else
      flash.now[:danger] = 'タスクが編集されませんでした'
      render :new
    end
  end

  def destroy
    @task.destroy

    flash[:success] = 'タスクが削除されました'
    redirect_to tasks_path

  end
  
  private
  
  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:content, :status)
  end
end

