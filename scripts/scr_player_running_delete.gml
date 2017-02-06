scr_player_movement();
if (onground && jump_pressed)
{
    vsp = -jumpspeed;
    sprite_index = spr_player_runjump; //change to runjump sprite
    run_jump = true;
    if (abs(hsp) <= runspeed + runjumpboost)
    {
        hsp += sign(hsp) * runjumpboost;
    }
}

if move != 0
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
}else
{
    //stay in runjump sprite until below running speed or gliding
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
    //currState = state.normal;
}
