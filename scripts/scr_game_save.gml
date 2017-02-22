if (file_exists(working_directory + "Save.sav")) {
    file_delete(working_directory + "Save.sav");
}

var saveFile = file_text_open_write(working_directory + "Save.sav");
var saveData = string(room)+":"+string(obj_player.x)+":"+string(obj_player.y);
show_debug_message(saveData);
file_text_write_string(saveFile, saveData);
file_text_close(saveFile);
