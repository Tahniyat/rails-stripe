class CreateSubscriptionPlans < ActiveRecord::Migration
  def change
    create_table :subscription_plans do |t|
      t.integer :id
      t.integer :amount
      t.string :description

      t.timestamps
    end
  end
end
