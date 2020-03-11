# frozen_string_literal: true

class Admins::SessionsController < Devise::SessionsController

  # GET /admin/sign_in
  def new
    super
  end

  # POST /admin/sign_in
  def create
    super
  end

  # DELETE /admin/sign_out
  def destroy
    super
  end

  # protected

end
