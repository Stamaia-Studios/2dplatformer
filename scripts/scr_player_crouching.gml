scr_player_movement();

// Add movement
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

// Let the player stand up only if there's nothing above them
if !down_pressed && !place_meeting(x, y-(sprite_height * 2), obj_wall) && !place_meeting(x, y-(sprite_height * 2), obj_platform_move)
{
    currState = state.normal;
}
