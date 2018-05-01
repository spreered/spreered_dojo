class ChangeDefaultName < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :name, :string, default: "", null: false
  end
end
