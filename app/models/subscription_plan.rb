class SubscriptionPlan < ActiveRecord::Base
	has_many :subscriptions
  attr_accessible :amount, :description, :id
end
