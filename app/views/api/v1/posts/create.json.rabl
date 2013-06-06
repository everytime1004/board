object false
node (:success) { true }
node (:info) { '글이 생성 되었습니다.' }
child :data do
  child @post do
    attributes :title, :description, :category
  end
end