# Controller to assign tasks to user
require 'pry'
require './app'
require './templates/task'
require './lib/slack'
require './lib/handler'

class TasksController < Sinatra::Base
  post '/tasks' do
    payload = parse_payload
    Handler.new(payload: payload).process
  end

  private

  def parse_payload
    JSON.parse(params[:payload], symbolize_names: true)
  end
end
