class CreateProviders < ActiveRecord::Migration[6.1]
  def change
    create_table :providers do |t|
      t.string :provider
      t.string :oauth_token
      t.datetime :oauth_expires_at
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
