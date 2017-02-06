// Calculate movement
move = -left_pressed + right_pressed; // Will be -1 for left and +1 for right
if(move != 0){
    facing = move;
}
crouchspeed = (basemovespeed * crouchmult) * movestatusmult; // Get current crouch speed
runspeed = (basemovespeed * runmult) * movestatusmult; // Get current run speed
movespeed = basemovespeed * movestatusmult; // Get current walk speed

// lock in facing direction of player
if(move > 0)
    facingDir = 1;
else if (move < 0)
    facingDir = -1;

// throw condition - set flag high if conditions are met (idle, moving, running, jumping only) !!!Moved to scr_player_normal
//throw_ok = (has_throwable || has_boomerang) && (!onground || running || move || move == 0) && !down_pressed && !gliding && !dashtrigger && !attackTrigger;

// pick up condition - set flag high if conditions met (idle, moving, running only)
pick_up_ok = onground && (running || move || move == 0) && !down_pressed && !dashtrigger && !attackTrigger;
pWall_pickup_chk = place_meeting(x, y+1, obj_pWall) | place_meeting(x, y-1, obj_pWall) | place_meeting(x+1, y, obj_pWall) | place_meeting(x-1, y, obj_pWall);
