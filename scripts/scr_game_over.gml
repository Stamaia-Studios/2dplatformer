//Create game over menu
gameOverMenu = instance_create(view_xview + view_wview * 0.25, view_xview + view_wview * 0.8, obj_menu);
gameOverMenu.menuIndex = 0;
gameOverMenu.menuOptions[0, 0] = "Restart";
gameOverMenu.menuOptions[0, 1] = scr_game_start;
gameOverMenu.menuOptions[1, 0] = "Exit";
gameOverMenu.menuOptions[1, 1] = scr_game_exit;
gameOverMenu.menuAlpha = 0.9;
