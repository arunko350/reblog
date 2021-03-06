class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :follow_user, :unfollow_user, :followers, :following]
  before_action :authenticate_user!
  require 'will_paginate/array'

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def follow_user
    current_user.follow!(@user)
    if current_user.follows?(@user)
      render html: "true"
    else
      render html: "false"
    end
  end

  def unfollow_user
    current_user.unfollow!(@user)
        if !current_user.follows?(@user)
          render html: "true"
        else
          render html: "false"
        end
  end

  def followers
    @users = @user.followers(User).paginate(:page => params[:page], :per_page => 10)
    @header = "Followers"
    respond_to do |format|
      format.html { render 'index' }
    end
  end

  def following
    @users = @user.followees(User).paginate(:page => params[:page], :per_page => 10)
    @header = "Following"
    respond_to do |format|
      format.html { render 'index' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = params[:id].present? ? User.find(params[:id]) : (params[:user_id].present? ? User.find(params[:user_id]) : nil)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :uid, :picture, :provider, :avatar)
    end
end
