/// @description Insert description here
// You can write your code in this editor
message_timer = current_time;
messages = ds_list_create();

/// Custom function to show messages
function add_message(text, duration) {
    var message = {
        text: text,
        timer: duration
    };
    ds_list_add(messages, message);
}

if (!variable_instance_exists(self, "already_shown")) already_shown = 0;
if (!variable_instance_exists(self, "gamepad_connected")) gamepad_connected = -1;
if (!variable_instance_exists(self, "gamepad_connected_now")) gamepad_connected_now = 0;