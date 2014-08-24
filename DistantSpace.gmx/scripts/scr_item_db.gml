empty_box = ds_map_create();
ds_map_add(empty_box, 'sprite', spr_test_obj);
ds_map_add(empty_box, 'type', 'misc');

human1_2_box = ds_map_create();
ds_map_add(empty_box, 'sprite', spr_human1_2);
ds_map_add(empty_box, 'type', 'human');

human1_3_box = ds_map_create();
ds_map_add(empty_box, 'sprite', spr_human1_3);
ds_map_add(empty_box, 'type', 'human');

human2_1_box = ds_map_create();
ds_map_add(empty_box, 'sprite', spr_human2_1);
ds_map_add(empty_box, 'type', 'human');

human2_3_box = ds_map_create();
ds_map_add(empty_box, 'sprite', spr_human2_3);
ds_map_add(empty_box, 'type', 'human');

//--------------------------------------

// Items DB

global.items = ds_map_create();
//ds_map_add(global.items,'obj_hat',hat);
ds_map_add(global.items,'obj_empty',empty_box);
ds_map_add(global.items,'obj_human1_2',human1_2_box);
ds_map_add(global.items,'obj_human1_3',human1_3_box);
ds_map_add(global.items,'obj_human2_1',human2_1_box);
ds_map_add(global.items,'obj_human2_3',human2_3_box);
