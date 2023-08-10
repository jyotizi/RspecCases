class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  
  def edit
    @user = User.find(params[:id])
    
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to user_url(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    @user = User.find(params[:id])
  
    if (@user.kind == "Teacher" || (@user.kind == "Student" && @user.enrollments.any?))
      flash[:error] = "Kind cannot be set to Student because the user is teaching in at least one program."
      redirect_to edit_user_path(@user)
    elsif @user.update(user_params)
      flash[:success] = "User updated successfully."
      redirect_to @user
    else
      render :edit
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end
    
    # def role_change_not_allowed?
    #   user_kind = user_params[:kind]
    #   current_kind = @user.kind
    #   
    #   if user_kind == current_kind
    #     return false 
    #   elsif (user_kind == "Student" && current_kind == "Teacher")
    #     return true 
    #   else  
    #     return false
    #   end
    # end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :age, :kind)
    end
end
