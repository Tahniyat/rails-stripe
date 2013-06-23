class Subscription < ActiveRecord::Base
	belongs_to :subscription_plan
  attr_accessible :email, :subscription_plan_id, :stripe_card_token
  
  attr_accessor :stripe_card_token
  
  def save_with_payment
    if valid?
      customer = Stripe::Customer.create(description: email, plan: subscription_plan_id, card: stripe_card_token)
      save!
    end
		rescue Stripe::InvalidRequestError => e
		  logger.error "Stripe error while creating customer: #{e.message}"
		  errors.add :base, "There was a problem with your credit card."
		  false
		end
end
