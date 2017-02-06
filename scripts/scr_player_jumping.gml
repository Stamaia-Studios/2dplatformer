scr_player_movement();

//Player falls due to gravity
if (vsp < maxfallspeed) vsp += grav;

// If changing movement directions, do this
if (sign(hsp) != sign(move) && move != 0 && hsp != 0)
{
    if (abs(hsp) <= movespeed)
    {
        sprite_index = spr_player;
        hsp += move * (movespeed/2); // Start moving in other direction by first cancelling out existing momentum, with slight penalty
    }
    else if(abs(hsp) > movespeed)
    {
        sprite_index = spr_player_run;
        hsp += move * (movespeed/8); // Start moving in other direction by first cancelling out existing momentum, with slight penalty
    }
}

// If under movement speed, do this
else if (abs(hsp) < movespeed && move != 0)
{
    sprite_index = spr_player;
    hsp = move * movespeed; // Move in direction at move speed
}
else if (abs(hsp) > movespeed && onground)
{
    hsp *= 0.97; // Exponential speed decay when recovering from running
}
else if (move == 0 && !onground && !run_jump) // If not pressing movement keys, do this
{
    hsp *= 0.9; // Exponential speed decay while in the air
}
else if (move == 0 && onground) // If not pressing movement keys, do this
{
    sprite_index = spr_player;
    hsp = 0; // Set speed to 0
}

// Start gliding
if sign(vsp) && keyboard_check(key_jump)
{
    currState = state.gliding;
    gliding = true;
}else if onground{
    currState = state.normal;
}
