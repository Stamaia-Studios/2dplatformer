scr_player_movement();

// Reset checks
fallthrough = false;

/*if((run_jump && abs(hsp) < basemovespeed*runmult) ||(run_jump && gliding)){
    sprite_index = spr_player; // Set to normal sprite and stop long jump
    run_jump =false;
}*/

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

/// Check for states ///

// Running
if (run_pressed && move != 0)
{
    currState = state.running;
}

// Jumping
if (onground && jump_pressed)
{
    currState = state.jumping;
    vsp = -jumpspeed;
}

// Throwing
throw_ok = (has_throwable || has_boomerang) && (!onground || running || move || move == 0)

// Crouching - 1.player is on ground OR 2.platform is above the player
if (down_pressed && onground) || (place_meeting(x, y-1, obj_platform_move))
{
    currState = state.crouching;
}

// Dashing
if (keyboard_check_pressed(vk_right))
{
    if(dash_right_timer > 0) 
    {
        dashtrigger = true;
        dash_right_timer = 0;
    }
    else
    {
        dash_right_timer = dash_timeout;
    }
    if(dash_left_timer > 0)
    {
        dash_left_timer = 0;
    }
}
else if (keyboard_check_pressed(vk_left))
{
    if(dash_left_timer > 0) 
    {
        dashtrigger = true;
        dash_left_timer = 0;
    }
    else
    {
        dash_left_timer = dash_timeout;
    }
    if(dash_right_timer > 0)
    {
        dash_right_timer = 0;
    }
}

if (attack_pressed && attackState==0 && dashAttackTimer == dashAttackCool) && onground
{
    currState = state.dashing;
}

// Attacking
switch(attackState){
    case 1:  //Set hsp to dash attack speed if in attack, but before decceleration
        hsp = dashDir*dashAttackSpeed; //direction and speed
        attackTrigger = true;
        sprite_index = spr_player_dash;
        break;
    case 2:  //stop player if crouch attacking
        hsp =0;
        attackTrigger = true;
        sprite_index = spr_player_crouch_attack;
        break;
}

if(dashAttackTimer < dashAttackCool && attackState != 1){//Decelerate from attack
    dashAttackTimer++;
    hsp = dashDir*dashAttackSpeed*(dashAttackCool-dashAttackTimer)/dashAttackCool;
    attackTrigger = false;
}else if(attackState == 0){
    attackTrigger = false;
}






