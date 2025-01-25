/// @description Insert description here
// You can write your code in this editor

message_shown = 0;
type_spr = [spr_lr, spr_lr2, spr_abxy, spr_abxy2, spr_lr_abxy_1, spr_lr_abxy_3, spr_lr_abxy_2, spr_lr_abxy_4];
pos_y = [523, 520, 584, 580, 523, 523, 520, 520];
selected_type = 0;
selected_element = 0;
editing_element = -1;
editing_elements = [];

prev_actions = [];
prev_actions_index = 0;
prev_pos_x_move_multiple = [];
prev_pos_x_move = 0;
copied_elements = [];
copy_message = current_time;
copy_type = 0; // copy: 0, paste: 1, cut: 2

current_key_timer = current_time;
advanced_controls_enabled = 0;
sync_ed = 0;
click_to_move = 0;
volume_message_timer = -1;

offsets = [];
sorted_edit_elements = [];
prev_type_backup = -1;
prev_pos_x_backup = -1;

// Copia de charteo siendo editado
if (array_length(global.current_chart) == 0) {
	global.current_chart = [];
	if (global.new_song_id == undefined || global.new_song_name == "") {
		for (var i = 0; i < array_length(global.charts[$ global.current_difficulty].charts[global.current_chart_index]); i++) {
			var element = global.charts[$ global.current_difficulty].charts[global.current_chart_index][i];
			array_push(global.current_chart, element);
		}	
	}
}

sort_elements_max_min_1 = [];
sort_elements_max_min_2 = [];
	
if (array_length(global.current_chart) > 0) {
	for (var i = 0; i < array_length(global.current_chart); i++) {
		var element = global.current_chart[i];
		if (element.index_type != 2 && element.index_type != 3) {
			array_push(sort_elements_max_min_1, element);
		}
		if (element.index_type != 0 && element.index_type != 1) {
			array_push(sort_elements_max_min_2, element);
		}
	}
	
	array_sort(sort_elements_max_min_1, function(a, b) { return b.pos_x - a.pos_x; });
    array_sort(sort_elements_max_min_2, function(a, b) { return b.pos_x - a.pos_x; });
}

// Agrega un elemento
add_charteo_element = function(index_type, pos_x) {
	var _find_index = -1;
	for (var i = 0; i < array_length(global.current_chart); i++) {
        var elem = global.current_chart[i];
        if (elem.pos_x == pos_x) {
			if (index_type == elem.index_type) {
		        _find_index = i;
		        break;
		    }
        }
    }
	if (_find_index == -1) {
		array_push(global.current_chart, {"index_type": index_type, "pos_x": pos_x});
		
		// Copias de mayor a menor
        if (index_type != 2 && index_type != 3) { // L_R
            array_push(sort_elements_max_min_1, {"index_type": index_type, "pos_x": pos_x});
            array_sort(sort_elements_max_min_1, function(a, b) { return b.pos_x - a.pos_x; });
        }
		if (index_type != 0 && index_type != 1) { // abxy
            array_push(sort_elements_max_min_2, {"index_type": index_type, "pos_x": pos_x});
            array_sort(sort_elements_max_min_2, function(a, b) { return b.pos_x - a.pos_x; });
        }
	}
}

// Elimina el elemento search del charteo
remove_charteo_element = function(search) {
    if (array_length(global.current_chart) > 0) {
        // Encuentra el índice del elemento a eliminar
        var _find_index = -1;
        for (var i = 0; i < array_length(global.current_chart); i++) {
            var elem = global.current_chart[i];
            if (elem.index_type == search.index_type && elem.pos_x == search.pos_x) {
                _find_index = i;
                break;
            }
        }
        
        // Si se encuentra, elimina el elemento
        if (_find_index != -1) {
            array_delete(global.current_chart, _find_index, 1);
			
			 // Eliminar los arreglos de mayor a menor
            if (search.index_type != 2 && search.index_type != 3) {
                for (var j = 0; j < array_length(sort_elements_max_min_1); j++) {
                    if (sort_elements_max_min_1[j].index_type == search.index_type && sort_elements_max_min_1[j].pos_x == search.pos_x) {
                        array_delete(sort_elements_max_min_1, j, 1);
                        break;
                    }
                }
            }
			if (search.index_type != 0 && search.index_type != 1) {
                for (var j = 0; j < array_length(sort_elements_max_min_2); j++) {
                    if (sort_elements_max_min_2[j].index_type == search.index_type && sort_elements_max_min_2[j].pos_x == search.pos_x) {
                        array_delete(sort_elements_max_min_2, j, 1);
                        break;
                    }
                }
            }

            // Reordenar los arreglos después de la eliminación
            array_sort(sort_elements_max_min_1, function(a, b) { return b.pos_x - a.pos_x; });
            array_sort(sort_elements_max_min_2, function(a, b) { return b.pos_x - a.pos_x; });
        }
    }
};