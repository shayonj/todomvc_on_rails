class SubTask < Todo
  after_update :todo_complete_if_sub_tasks_complete, if: ->(todo){ todo.type == "SubTask" }
  belongs_to :todo, foreign_key: :parent_id

  def todo_complete_if_sub_tasks_complete
    todo.update_attribute(:completed, true) if todo.sub_tasks.count == todo.sub_tasks.completed.count
  end

end
