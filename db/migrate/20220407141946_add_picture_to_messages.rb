class AddPictureToMessages < ActiveRecord::Migration[6.1]
  def change
    add_column :messages, :picture, :string
  end
end
