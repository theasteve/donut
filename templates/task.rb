module Template
  TASK_TEMPLATE = {
    "type": "modal",
    "title": {
      "type": "plain_text",
      "text": "Task",
      "emoji": true
    },
    "submit": {
      "type": "plain_text",
      "text": "Submit",
      "emoji": true
    },
    "close": {
      "type": "plain_text",
      "text": "Cancel",
      "emoji": true
    },
    "blocks": [
      {
        "type": "divider"
      },
      {
        "type": "input",
        "element": {
          "type": "plain_text_input",
          "action_id": "plain_text_input-action"
        },
        "label": {
          "type": "plain_text",
          "text": "Task Description:",
          "emoji": true
        }
      },
      {
        "type": "input",
        "element": {
          "type": "users_select",
          "placeholder": {
            "type": "plain_text",
            "text": "Select users",
            "emoji": true
          },
          "action_id": "users_select-action"
        },
        "label": {
          "type": "plain_text",
          "text": "Select Teammate:",
          "emoji": true
        }
      }
    ]
  }

  TASK_COMPLETE_TEMPLATE = {
    "type": "modal",
    "title": {
      "type": "plain_text",
      "text": "Notify",
      "emoji": true
    },
    "submit": {
      "type": "plain_text",
      "text": "Submit",
      "emoji": true
    },
    "close": {
      "type": "plain_text",
      "text": "Cancel",
      "emoji": true
    },
    "blocks": [
      {
        "type": "section",
        "text": {
          "type": "mrkdwn",
          "text": "Notify your teammate *that the task is complete*."
        }
      },
      {
        "type": "section",
        "text": {
          "type": "mrkdwn",
          "text": "Select teammate:"
        },
        "accessory": {
          "type": "users_select",
          "placeholder": {
            "type": "plain_text",
            "text": "Select a user",
            "emoji": true
          },
          "action_id": "users_select-action"
        }
      }
    ]
  }
end
