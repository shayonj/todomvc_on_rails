class AddParentIdAndTypeToTodos < ActiveRecord::Migration
  def change
    add_column :todos, :parent_id, :integer, index: true
    add_column :todos, :type, :string
  end
end
