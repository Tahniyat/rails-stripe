class AlterColumnNameInSubscription < ActiveRecord::Migration
  def up
  	rename_column :subscriptions, :plan_id, :subscription_plan_id
  end

  def down
  end
end
