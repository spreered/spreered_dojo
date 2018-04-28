class WhoCanSeeToInteger < ActiveRecord::Migration[5.1]
  def change
    remove_column :posts, :who_can_see
    add_column :posts, :who_can_see, :integer, null: false, default: 0
  end
end
