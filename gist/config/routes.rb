Rails.application.routes.draw do
  get 'note_records' => 'note_records#stream'
end
