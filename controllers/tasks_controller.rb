# Controller to assign tasks to user
require 'pry'
require './app'
require './templates/task'
require './lib/slack'

class TasksController < Sinatra::Base
  include Template

  post '/tasks' do
    payload = sanitize_payload
    slack_client = SlackAdapter.new
    if payload[:type] == 'view_submission' && payload[:view][:title][:text] == 'Notify'
      notification = OpenStruct.new(
        sender: payload[:user][:id],
        receiver: get_user_from_submission(payload),
        message: task_completed_message(payload)
      )

      slack_client.chat_message_to_user(
        users: notification.receiver,
        text: notification.message
      )

      200
    elsif payload[:type] == 'view_submission' && payload[:view][:title][:text] == 'Task'
      task = OpenStruct.new(
        requester: payload[:user][:id],
        assignee: get_user_from_submission(payload),
        message: task_assignee_message(payload),
        description: task_description(payload)
      )
      slack_client.chat_message_to_user(
        users: task.assignee,
        text: task.message,
        description: task.description
      )
      200
    elsif payload[:type] == 'shortcut' && payload[:callback_id] == 'assign_task'
      slack_client.views_open(
        trigger_id: payload[:trigger_id],
        view: task_template
      )
      200
    elsif payload[:type] == 'shortcut' && payload[:callback_id] == 'task_complete'
      slack_client.views_open(
        trigger_id: payload[:trigger_id],
        view: task_complete_template
      )
      200
    end
  end

  private

  USERS_SELECTED_FIELD = :"users_select-action"
  USERS_SELECTED_KEY = :selected_user
  TASK_DESCRIPTION_FIELD = :"plain_text_input-action"
  TASK_DESCRIPTION_KEY = :value

  def task_completed_message(payload)
    user = get_user_from_submission(payload)
    "Hi <@#{user}>!, this message is to notify you that " \
      "the task is complete by <@#{payload[:user][:id]}>!"
  end

  def task_assignee_message(payload)
    description = task_description(payload)
    user = get_user_from_submission(payload)

    "Hi <@#{user}>!, you have been assigned the " \
      "following task:  *#{description}* by <@#{payload[:user][:id]}>."
  end

  def task_template
    Template::TASK_TEMPLATE
  end

  def task_complete_template
    Template::TASK_COMPLETE_TEMPLATE
  end

  def sanitize_payload
    JSON.parse(params[:payload], symbolize_names: true)
  end

  def get_submission_values(payload)
    payload[:view][:state][:values]
  end

  def get_user_from_submission(payload)
    get_values_from_view_submission(
      values: get_submission_values(payload),
      key: USERS_SELECTED_KEY,
      field: USERS_SELECTED_FIELD
    )
  end

  def task_description(payload)
    get_values_from_view_submission(
      values: get_submission_values(payload),
      key: TASK_DESCRIPTION_KEY,
      field: TASK_DESCRIPTION_FIELD
    )
  end

  # This method retrieves the values from a view_submission payload
  # https://api.slack.com/reference/interaction-payloads/views#view_submission_example
  def get_values_from_view_submission(args = {})
    args[:values].each do |k, v|
      return v.dig(args[:field])[args[:key]] if v.key?(args[:field])
    end
  end
end
