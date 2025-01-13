/// @description Insert description here
// You can write your code in this editor

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(splat_font_title);
var msg_x = 15;
var msg_y = display_get_gui_height() - 50;
var line_height = 20;

for (var i = 0; i < ds_list_size(messages); i++) {
    var message_to_do = messages[| i];
    draw_set_color(c_black);
    draw_rectangle(msg_x - 5, msg_y - 8, msg_x + string_width(message_to_do.text) + 5, msg_y + 45, false);
    draw_set_color(c_white);
    draw_text(msg_x, msg_y, message_to_do.text);
    msg_y -= line_height;
    message_to_do.timer -= 1;
    messages[| i] = message_to_do; // Update timer
}

// Remove expired messages
for (var i = ds_list_size(messages) - 1; i >= 0; i--) {
    if (messages[| i].timer <= 0) {
        ds_list_delete(messages, i);
    }
}