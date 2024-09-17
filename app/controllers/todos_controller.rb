require ('sidekiq/api')
class TodosController < ApplicationController
  before_action :set_todo, only: %i[ show edit update destroy change_status ]

  def change_status
    @todo.update(status: todo_params[:status])
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove("#{helpers.dom_id(@todo)}_container") }
      format.html { redirect_to todos_path, notice: "Updated todo status." }
    end
  end
  # GET /todos or /todos.json
  def index
    Rails.logger.info 'Index view accessed'
    last_todo = Todo.last
    # @todos = Todo.where(status: params[:status].presence || 'incomplete')
    

    if params[:id]
      @user = User.find(params[:id])
      @todos = @user.todos.where(status: params[:status].presence || 'incomplete')
    else
      @todos = Todo.where(status: params[:status].presence || 'incomplete')
    end
    puts params[:status].presence
    # @todos = User.todos_for_user(2).where(status: params[:status].presence || 'incomplete')
    # @todos = Todo.where(status: params[:status].presence || 'incomplete')
  end

  # GET /todos/1 or /todos/1.json
  def show
  end

  # GET /todos/new
  def new
    @todo = Todo.new

  end

  # GET /todos/1/edit
  def edit
    @default_due_date = 1.day.from_now.in_time_zone('Asia/Bangkok').strftime('%d-%m-%Y %H:%M')
  end

  # DELETE /todos/reset
  # destroy_all
  def destroy_all
    Todo.destroy_all
    respond_to do |format|
      format.html { redirect_to todos_url, notice: "Todo was successfully reseted." }
    end
  end

  # POST /todos or /todos.json
  def create
    @todo = Todo.new(todo_params)

    respond_to do |format|
      if @todo.save
        Rails.logger.info 'Create new todo #'

        format.turbo_stream
        format.html { redirect_to todo_url(@todo), notice: "Todo was successfully created." }
        format.json { render :show, status: :created, location: @todo }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace("#{helpers.dom_id(@todo)}_form", partial: "form", locals: { todo: @todo }) }
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /todos/1 or /todos/1.json
  def update

    if params[:todo][:duedate].present?
      local_due_date = params[:todo][:duedate].to_time.in_time_zone('Asia/Bangkok')
      utc_due_date = local_due_date.utc
      params[:todo][:duedate] = utc_due_date
    end

    respond_to do |format|
      if @todo.update(todo_params)

          # Cancel the previously scheduled job (if it exists)
          if params[:todo][:duedate].present?
            expiration_time = @todo.duedate.in_time_zone('UTC')
            delay_in_seconds = ((expiration_time - Time.current)).to_i




            new_job = ToDoExpireJob.set(wait: delay_in_seconds.seconds).perform_later(@todo)

            @todo.update(notifyID: new_job.job_id)
          end

        format.turbo_stream
        format.html { redirect_to todo_url(@todo), notice: "Todo was successfully updated." }
        format.json { render :show, status: :ok, location: @todo }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace("#{helpers.dom_id(@todo)}_form", partial: "form", locals: { todo: @todo }) }
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /todos/1 or /todos/1.json
  def destroy
    if @todo.notifyID.present?

      scheduled_set = Sidekiq::ScheduledSet.new
      job = scheduled_set.find_job(@todo.notifyID)
      job&.delete

    end
    @todo.destroy!

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove("#{helpers.dom_id(@todo)}_container") }
      format.html { redirect_to todos_url, notice: "Todo was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_todo
      @todo = Todo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def todo_params
      params.require(:todo).permit(:name, :duedate, :status , :user_id)
    end
end
