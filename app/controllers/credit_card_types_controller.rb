class CreditCardTypesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_setting

  def create
    @credit_card_type = @user_setting.credit_card_types.new(credit_card_type_params)

    if @credit_card_type.save
      redirect_to user_setting_path, notice: "Credit card type added."
    else
      @credit_card_types = @user_setting.credit_card_types.order(created_at: :desc)
      render "user_settings/show", status: :unprocessable_entity
    end
  end

  private

  def set_user_setting
    @user_setting = current_user.user_setting || current_user.build_user_setting
  end

  def credit_card_type_params
    params.require(:credit_card_type).permit(:bank_name, :last4)
  end
end
