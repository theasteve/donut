require './lib/slack'

# Handle the requests made by the Slack API
class Handler
  attr_accessor :payload, :slack_client

  def initialize(payload:, slack_client: SlackAdapter.new)
    @payload = payload
    @slack_client = slack_client
  end

  def self.process
    if task_complete_request?
      send_message_to_notify_task_completed
    elsif task_assigned_request?
      send_message_to_assig_task
    elsif open_task_assign_modal_request?
      open_assign_task_modal
    elsif open_task_complete_modal_request?
      open_task_complete_modal
    end
  end

  def task_complete_request?
    @payload[:type] == 'view_submission' && @payload[:view][:title][:text] == 'Notify'
  end

  def task_assigned_request?
    @payload[:type] == 'view_submission' && @payload[:view][:title][:text] == 'Task'
  end

  def open_task_assign_modal_request?
    @payload[:type] == 'shortcut' && @payload[:callback_id] == 'assign_task'
  end

  def open_task_complete_modal_request?
    @payload[:type] == 'shortcut' && @payload[:callback_id] == 'task_complete'
  end

  private

  USERS_SELECTED_FIELD = :"users_select-action"
  USERS_SELECTED_KEY = :selected_user
  TASK_DESCRIPTION_FIELD = :"plain_text_input-action"
  TASK_DESCRIPTION_KEY = :value

  def send_message_to_notify_task_completed
    @slack_client.chat_message_to_user(
      users: get_user_from_submission,
      text: task_completed_message
    )
    200
  end

  def send_message_to_assig_task
    @slack_client.chat_message_to_user(
      users: get_user_from_submission,
      text: task_assignee_message
    )
    200
  end

  def open_assign_task_modal
    @slack_client.views_open(
      trigger_id: @payload[:trigger_id],
      view: task_template
    )
    200
  end

  def open_task_complete_modal
    @slack_client.views_open(
      trigger_id: payload[:trigger_id],
      view: task_complete_template
    )
    200
  end

  def task_completed_message
    user = get_user_from_submission
    "Hi <@#{user}>!, this message is to notify you that " \
      "the task is complete by <@#{@payload[:user][:id]}>!"
  end

  def task_assignee_message
    description = task_description
    user = get_user_from_submission

    "Hi <@#{user}>!, you have been assigned the " \
      "following task:  *#{description}* by <@#{@payload[:user][:id]}>."
  end

  def task_template
    Template::TASK_TEMPLATE
  end

  def task_complete_template
    Template::TASK_COMPLETE_TEMPLATE
  end

  def get_submission_values
    @payload[:view][:state][:values]
  end

  def get_user_from_submission
    get_values_from_view_submission(
      values: get_submission_values,
      key: USERS_SELECTED_KEY,
      field: USERS_SELECTED_FIELD
    )
  end

  def task_description
    get_values_from_view_submission(
      values: get_submission_values,
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
