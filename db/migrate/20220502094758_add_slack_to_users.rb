class AddSlackToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :slack_access_token, :string
    add_column :users, :slack_incoming_webhook_url, :string
  end
end
