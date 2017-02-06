///Movement and Collision
scr_player_movement();

// Check for dash triggers (double press right or left)
if (keyboard_check_pressed(vk_right))
{
    if(dash_right_timer > 0) 
    {
        dashtrigger = true;
        currState = state.dashing;
        dash_right_timer = 0;
    }
    else
        dash_right_timer = dash_timeout;
    if(dash_left_timer > 0)
        dash_left_timer = 0;
}
else if (keyboard_check_pressed(vk_left))
{
    if(dash_left_timer > 0) 
    {
        dashtrigger = true;
        currState = state.dashing;
        dash_left_timer = 0;
    }
    else
        dash_left_timer = dash_timeout;
    if(dash_right_timer > 0)
        dash_right_timer = 0;
}

// Set running to false, and only set it to true if dashing has happened with tap-to-run or the run key is held without tap-to-run
running = false;
if (dashtrigger && taptorun && onground)
{
    currstate = state.running;
    running = true;
}
else if (run_pressed && !taptorun && onground)
{
    currstate = state.running;
    running = true;
}

// Slide/crouch if touching ground and holding down or under an object that is short than the player and already crouhing/sliding
if((down_pressed && onground && dashAttackTimer == dashAttackCool) || (sprite_index == spr_player_crouching && place_meeting(x, y-(sprite_height+1), obj_wall)))
{
    sprite_index = spr_player_crouching; // Set to crouching/sliding sprite
    if(attack_pressed && attackState == 0){//if pressing attack and not already attacking
        hsp = 0; //stop player, set attack state, change to crouch attack sprite, and create hitbox
        attackState = 2;
        sprite_index = spr_player_crouch_attack;
        instance_create(x+((sprite_width)*facing), y+(sprite_height)/2, obj_hb_crouch);//create the crouch attack hitbox object
    }else if (abs(hsp) > movespeed) // Slide if moving faster than base movement speed
    {
        hsp *= 0.99 // Exponentially decrease speed
        if (abs(hsp) < crouchspeed) hsp = sign(hsp) * crouchspeed; // If speed is now below the normal crouch speed, set it to that
    }
    else
    {
        hsp = move * crouchspeed; // Crouch walk in a direction
    }
}
else if (running && move != 0) // Check if running
{
    sprite_index = spr_player_run; // Set to normal sprite
    if (sign(hsp) != sign(move) && move != 0 && hsp != 0) // If changing movement directions, do this
    {
        hsp += move * (movespeed/8); // Start moving in other direction by first cancelling out existing momentum, with slight penalty
    }
    else if (attack_pressed && attackState==0 && dashAttackTimer == dashAttackCool){//check if able to dash attack
        instance_create(x+((sprite_width*1.5)*move), y, obj_hb_dash);//create the dash attack hitbox object
        dashAttackTimer = 0;//dash attack cool down reset
        attackState = 1;//is attacking
        dashDir = move;//attack direction
        sprite_index = spr_player_dash;
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
}
else
{       //stay in runjump sprite until below running speed or gliding
    if((run_jump && abs(hsp) < basemovespeed*runmult) ||(run_jump && gliding)){ 
        sprite_index = spr_player; // Set to normal sprite and stop long jump
        run_jump =false;
    }
    
    if (sign(hsp) != sign(move) && move != 0 && hsp != 0) // If changing movement directions, do this
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
    else if (abs(hsp) < movespeed && move != 0) // If under movement speed, do this
    {
        sprite_index = spr_player;
        hsp = move * movespeed; // Move in direction at move speed
    }
    else if (abs(hsp) > movespeed && onground)
    {
        hsp *= 0.97; // Exponential speed decay when recovering from running
        //if (abs(hsp) <= movespeed) hsp = move * movespeed; // If below move speed, set to move speed
    }
    else if (move == 0 && !onground && !run_jump) // If not pressing movement keys, do this
    {
        hsp *= 0.9; // Exponential speed decay while in the air
        //if (abs(hsp) < movespeed) hsp = 0; // If below base speed, stop
    }
    else if (move == 0 && onground) // If not pressing movement keys, do this
    {
        sprite_index = spr_player;
        hsp = 0; // Set speed to 0
    }
}

// Allow jumping if on floor, but don't allow it if on a platform, crouching, and not moving or while dash attacking
if (onground && jump_pressed)
{
    vsp = -jumpspeed;
}

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
