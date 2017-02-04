show_debug_message("NORMAL");

if place_meeting(x, y+1, obj_platform_move)
{
    currState = state.platform;
}

// Calculate movement
move = -left_pressed + right_pressed; // Will be -1 for left and +1 for right
if(move != 0){
    facing = move;
}

// Check if dashing has stopped and if so, set dashtrigger to false
if (move == 0 && dashtrigger){ dashtrigger = false; }

// lock in facing direction of player
if(move > 0){
    facingDir = 1;
}else if (move < 0){
    facingDir = -1;
}

// If in fallthrough and down key has been released or have touched ground, exit fallthrough
if ((keyboard_check_released(key_down) || onground) && fallthrough)
{
    fallthrough = false;
}

// throw condition - set flag high if conditions are met (idle, moving, running, jumping only)
throw_ok = (has_throwable || has_boomerang) && (!onground || running || move || move == 0) && !down_pressed && !gliding && !dashtrigger && !attackTrigger;

// pick up condition - set flag high if conditions met (idle, moving, running only)
pick_up_ok = onground && (running || move || move == 0) && !down_pressed && !gliding && !dashtrigger && !attackTrigger;
pWall_pickup_chk = place_meeting(x, y+1, obj_pWall) | place_meeting(x, y-1, obj_pWall) | place_meeting(x+1, y, obj_pWall) | place_meeting(x-1, y, obj_pWall);

// Check for dash triggers (double press right or left)
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

// Set running to false, and only set it to true if dashing has happened with tap-to-run or the run key is held without tap-to-run
running = false;
if (dashtrigger && taptorun && onground) { running = true; currState = state.dashing; } else
if (run_pressed && !taptorun && onground){ running = true; currState = state.dashing; }

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
{/*
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
    }*/
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

if (vsp < maxfallspeed) vsp += grav; // Increase downward movement speed based on gravity

// Allow jumping if on floor, but don't allow it if on a platform, crouching, and not moving or while dash attacking
if (onground && !(place_meeting(x, y+1, obj_platform) && hsp == 0 && down_pressed) && dashAttackTimer == dashAttackCool && jump_pressed)
{
    vsp = -jumpspeed;
    if(running){ // check if running when jumping
        sprite_index = spr_player_runjump; //change to runjump sprite
        run_jump = true;
        if (abs(hsp) <= runspeed + runjumpboost)
            hsp += sign(hsp) * runjumpboost;
    }
    //else if(abs(hsp) <= movespeed + jumpboost) 
    //hsp += sign(hsp) * jumpboost;
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

if(inv<1){//this will allow movement through enemies during damage frames
//TODO ADD ENEMIES HERE
/*
if(instance_exists(obj_blep))//make sure the enemy exists
if(place_meeting(x, y, obj_blep))//checks if the enemy meets the player
hp--;//subtracts health away from player and triggers damage handling
/*/
}

/*

End Of Every Step Handlers
• Out Of Bounds Checking
    • Respawning
• Death
    • Reset Variables
• Enemy Damage Handing
    • Assuming the character moves into an enemy, knockback will be applied accordingly
    
*/

//sets the direction facing to the current direction if moving or changing direction
if(move!=0)last_dir=move;

//Check if out of bounds, and cause damage to the player for death
//added some numbers for more leniency with auto killing
//there is no top kill -- gravity is assumed to pull the character back down
if((self.x<-200)||(self.x>room_width+200)||(self.y>room_height+200)){
    //invincibility frame correcting
    last_hp=0;
    hp=0;//auto kills the player
}

//checks for death
if(hp<1){
    hsp=0;vsp=1; //sets speeds back to zero to prevent conflicts with spawn setup
    x=spawn[0];y=spawn[1];//sets the actual position back to start
    inv=inv_frames;//1/3rd of a second at 60fps, of damage invulnerability
    hp=max_hp;//resets health to prevent this death hadnler from running again
    last_hp=hp;//invincibility frame correcting
}

if(hp!=last_hp){//damage frames handler
    if(inv<1){//makes sure the player is not still invincible
    //even if this is called after death reset, it will be equivalent
    inv=inv_frames;
    //reset health for more damage checking
    last_hp=hp;
    }else hp = last_hp;//if invincible, reset health to prior
    /*
    Added/Optional Knockback Handler
        • Reversed Movements attempt to handle situations where the character may become stuck
    */
    //makes sure the recoil is 8, horizontally
    if(hsp==0){
        hsp=-last_dir*8;
    }else{//if this is not 0, then make sure the recoil is = (+8 || -8)
        if((abs(hsp)<8)||(abs(hsp)>8))
        hsp=8*-sign(move);
    }
    
    //OPTIONAL -- Currently on
    //sets the last direction moved the the direction of the damage
    /*this may cause infinte bounce loops, but it preents the player
    from getting bumped all the way to start, assuming tanking though
    a line of enmies*/
    if(hsp!=0)
    last_dir=sign(hsp);//sign is the direction of damage
    
    vsp=-vsp;//-1 = 100% knockback -- -2 = 200% knockback
}

//Setting Damage Sprites, clickering every 6th frame FOR 3 FRAMES
if(inv>0&&inv%6<3){
    if(image_alpha<1)
    image_alpha=1;//100% opaque
    else image_alpha=.2;//20% opaque
    if(inv-1<1)image_alpha=1;//make sure the sprite is not stuck at .3/1 opacity
}
//removes invincibility frames until none exist
if(inv>0)inv--;


