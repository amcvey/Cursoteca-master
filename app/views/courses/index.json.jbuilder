json.array!(@courses) do |course|
  json.extract! course, :id, :photo, :title, :place, :description, :punctuation, :price, :category
  json.url course_url(course, format: :json)
end
