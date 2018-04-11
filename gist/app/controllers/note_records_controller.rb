class NoteRecordsController < ApplicationController
  include ActionController::Live

  def stream
    response.headers['Content-Type'] = 'text/event-stream'
    # TODO throw some kind of error around person being null
    person = PersonRecord.find_by_id(params[:id]) || = PersonRecord.find_by_email(params[:email])

    NoteRecord.by_person_records(person).recently_created_first.find_each do |note|
      response.stream.write "Last updated at: #{note.updated_at}\n"
      response.stream.write "Identifier: #{note.id}\n"
      response.stream.write "#{note.text}\n"
      response.stream.write "\n"
    end
  ensure
    response.stream.close
  end
end
