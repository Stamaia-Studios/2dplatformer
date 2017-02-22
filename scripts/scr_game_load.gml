if file_exists(working_directory + "Save.sav") {
    var loadFile = file_text_open_read(working_directory + "Save.sav");
    var loadData = file_text_read_string(loadFile);
    file_text_close(loadFile);
    
    var counter = 0;
    var currentString = "";
    var i = 1;
    for (i = 1; i < string_length(loadData) + 1; i++)
    {
        if string_char_at(loadData,i) == ":"
        {
            allData[counter] = currentString;
            currentString = "";
            counter++
        } else {
            currentString = currentString + string_char_at(loadData,i);
        }
    }
    allData[counter] = currentString;
    
    room_goto(real(allData[0]));
    global.playerSpawnX = real(allData[1]);
    global.playerSpawnY = real(allData[2]);
}
