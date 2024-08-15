class PagesController < ApplicationController

  def home
    @resource = User.new  # or `current_user` if you want to pass the current logged-in user
    @resource_name = :user
    @devise_mapping = Devise.mappings[:user]
  end

  def about
  end

end
