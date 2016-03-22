class SubTask < Todo
  belongs_to :todo, foreign_key: :parent_id
end
