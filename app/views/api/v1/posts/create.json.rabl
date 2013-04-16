object false
node (:success) { true }
node (:info) { 'Task created!' }
child :data do
  child @post do
    attributes :title, :description, :category
  end
end