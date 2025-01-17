/// @description Insert description here
// You can write your code in this editor

proportion_bpm_to_speed = 132 / 3600;
total_notes = 0;
type_spr = [spr_lr, spr_lr2, spr_abxy, spr_abxy2, spr_lr_abxy_1, spr_lr_abxy_3, spr_lr_abxy_2, spr_lr_abxy_4];
pos_y = [459, 456, 518, 516, 459, 459, 456, 456];
pos_y_lose = 0;

if (!variable_global_exists("is_playing")) {
    global.is_playing = 0;
}