class Todo < ActiveRecord::Base
  after_update :todo_complete_if_sub_tasks_complete, if: ->(todo){ todo.type == "SubTask" }
  after_update :sub_tasks_complete_if_task_complete, if: ->(todo){ todo.type != "SubTask" }
  after_update :mass_update_sub_tasks_if_task_complete, if: ->(todo){ todo.type != "SubTask" }

  scope :completed, -> { where("completed = ?", true) }
  scope :active, -> { where("completed = ?", false) }
  scope :main_tasks, -> { where(parent_id: nil) }

  has_many :sub_tasks, foreign_key: :parent_id, dependent: :destroy

  def title=(title)
    write_attribute(:title, title.strip)
  end

  def todo_complete_if_sub_tasks_complete
    todo.update_attribute(:completed, true) if todo.sub_tasks.count == todo.sub_tasks.completed.count
  end

  def sub_tasks_complete_if_task_complete
    sub_tasks.update_all(completed: true) if completed
  end

  def mass_update_sub_tasks_if_task_complete
    sub_tasks.update_all(completed: completed)
  end

  def is_sub_task?
    type == "SubTask"
  end
end
