/// @description Insert description here
// You can write your code in this editor

// PLAYER INPUTS
player_input = ["A", "S", "D", "F", "H", "J", "K", "L"]
if (global.is_gamepad) player_input = [gp_shoulderl, gp_shoulderlb, gp_shoulderr, gp_shoulderrb, gp_face1, gp_face2, gp_face3, gp_face4, gp_padu, gp_padd, gp_padl, gp_padr];

// INPUT READ
x = 250;
type_spr = [spr_lr, spr_lr2, spr_abxy, spr_abxy2, spr_lr_abxy_1, spr_lr_abxy_3, spr_lr_abxy_2, spr_lr_abxy_4];
current_element_index = 0;
input_sync_type = -1;
input_buffer = [];
delay_to_input = 400;

elements = [];
for (var i = 0; i < array_length(global.charts[$ global.current_difficulty].charts[global.current_chart_index]); i++) {
	var element = global.charts[$ global.current_difficulty].charts[global.current_chart_index][i];
	array_push(elements, element);
}
array_sort(elements, function(a, b) { return a.pos_x - b.pos_x; });

count_lr = 0;
count_abxy = 0;
double_lr = 0;
double_abxy = 0;
lr_times = [];
abxy_times = [];

// POINTS AND FEEDBACK
local_count_silver = 0;
local_count_gold = 0;
local_total_hits = -1;
sound_delay_lr = current_time;
sound_delay_lr2 = current_time;
sound_delay_abxy = current_time;
combo_count = 0;

type_of_hit = 0;
missed_or_pressed_type = 0;

last_input_time = current_time;
last_win_category = ""
text_timer = current_time;
animation_timer = current_time;
animation_frame = 0;
wait_for_animation_timer = current_time;
rect_color = global.primary_color_yellow;
already_hit = [];

current_life = 100;
game_over_message = 0;
y_gameover = 0;
x_gameover = 0;
rot_gameover = 0;
game_over_timer = -1;
auto_bot_enabled = 0;

// GAME WIN
game_win = 0;
game_win_for_first_time = 0;
if (global.current_chart_index != 0) {
	if ((array_length(elements) - global.game_points[$ global.current_difficulty].total_hits[global.current_chart_index]) > 0) {
		game_win = 1;
	}
}

// FIXED COORDS FOR EFFECTS
pos_y = [459, 456, 518, 516, 459, 459, 456, 456];
pos_y_hit = [];
pos_x_hit = [];
hit_timer = current_time;
alpha_hit = [];

// Función para manejar la lógica del auto bot
function auto_bot_action(element, sprite_x_start, sprite_x_end) {
    // Definir los inputs simulados según el index_type
    var abxy_pressed = false;
    var lr_pressed = false;
    var lr2_pressed = false;
	
	if (sprite_x_start <= x + sprite_width + 20 && sprite_x_end >= x && abs(sprite_x_start - 272) / (sprite_width) < 0.93 && abs(sprite_x_start - 272) / (sprite_width) > 0.5) {
	    switch (element.index_type) {
	        case 0: 
				array_push(input_buffer, {type: "lr", time: current_time});
				lr_pressed = true;
				break;
			case 1:
	            array_push(input_buffer, {type: "lr", time: current_time});
				array_push(input_buffer, {type: "lr", time: current_time});
				lr2_pressed = true;
	            break;
	        case 2:
				array_push(input_buffer, {type: "abxy", time: current_time});
				abxy_pressed = true;
				break;
			case 3:
	            array_push(input_buffer, {type: "abxy", time: current_time});
				array_push(input_buffer, {type: "abxy", time: current_time});
				abxy_pressed = true;
	            break;
	        case 4:
				array_push(input_buffer, {type: "lr", time: current_time});
				array_push(input_buffer, {type: "abxy", time: current_time});
				lr_pressed = true;
	            abxy_pressed = true;
	            break;
	        case 5:
	            array_push(input_buffer, {type: "lr", time: current_time});
				array_push(input_buffer, {type: "abxy", time: current_time});
				array_push(input_buffer, {type: "abxy", time: current_time});
				lr_pressed = true;
	            abxy_pressed = true;
	            break;
	        case 6:
	            array_push(input_buffer, {type: "lr", time: current_time});
				array_push(input_buffer, {type: "lr", time: current_time});
				array_push(input_buffer, {type: "abxy", time: current_time});
				lr2_pressed = true;
	            abxy_pressed = true;
	            break;
	        case 7:
	            array_push(input_buffer, {type: "lr", time: current_time});
				array_push(input_buffer, {type: "lr", time: current_time});
				array_push(input_buffer, {type: "abxy", time: current_time});
				array_push(input_buffer, {type: "abxy", time: current_time});
				lr2_pressed = true;
	            abxy_pressed = true;
	            break;
	    }
	}
	return [abxy_pressed, lr_pressed, lr2_pressed];
}
