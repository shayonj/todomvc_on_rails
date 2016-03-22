class Todo < ActiveRecord::Base
  scope :completed, -> { where("completed = ?", true) }
  scope :active, -> { where("completed = ?", false) }
  scope :main_tasks, -> { where(parent_id: nil) }

  has_many :sub_tasks, foreign_key: :parent_id, dependent: :destroy

  after_update :sub_tasks_complete_if_task_complete, if: ->(todo){ todo.type != "SubTask" }
  after_update :mass_update_sub_tasks_if_task_complete, if: ->(todo){ todo.type != "SubTask" }

  def title=(title)
    write_attribute(:title, title.strip)
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
