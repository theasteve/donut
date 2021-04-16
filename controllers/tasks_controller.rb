# Controller to assign tasks to user
require 'pry'
require './app'
require './templates/task'
require './lib/slack'
require './lib/handler'

class TasksController < Sinatra::Base
  include Template

  post '/tasks' do
    payload = sanitize_payload
    Handler.new(payload: payload).process
  end

  private

  def sanitize_payload
    JSON.parse(params[:payload], symbolize_names: true)
  end
end
