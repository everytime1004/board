object false
node (:success) { true }
node (:info) { 'ok' }
child :data do
  node (:comments_count) { @comments.size }
  child @comments do
    attributes :id, :author, :contents, :updated_at
  end
end