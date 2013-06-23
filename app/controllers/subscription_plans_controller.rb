class SubscriptionPlansController < ApplicationController
  # GET /subscription_plans
  # GET /subscription_plans.json
  def index
    @subscription_plans = SubscriptionPlan.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @subscription_plans }
    end
  end
  
end
