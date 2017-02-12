scr_player_movement();

// Check if dashing has stopped and if so, set dashtrigger to false
if (move == 0 && dashtrigger)
{
    dashtrigger = false;
}

currState = state.normal;
