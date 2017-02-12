scr_player_movement();

// Run
sprite_index = spr_player_run; // Set to normal sprite
if (sign(hsp) != sign(move) && move != 0 && hsp != 0) // If changing movement directions, do this
{
    hsp += move * (movespeed/8); // Start moving in other direction by first cancelling out existing momentum, with slight penalty
}
else if (abs(hsp) < runspeed && move != 0) // If under run speed, do this
{
    hsp += (move * runspeed)*0.1; // Move in direction at run speed
    if (abs(hsp) > runspeed) hsp = move * runspeed;
}
else if (abs(hsp) > runspeed && onground)
{
    hsp *= 0.96;
}

// Jump
if (onground && jump_pressed)
{
    sprite_index = spr_player;
    currState = state.jumping;
    vsp = -jumpspeed;
}

// Stop running
if !run_pressed || move = 0
{
    sprite_index = spr_player;
    currState = state.normal;
}
