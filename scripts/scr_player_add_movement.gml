
hsp_final = hsp + hsp_carry;
hsp_carry = 0;

// Horizonatal collision aka don't go through the walls
if (place_meeting(x+hsp_final, y, obj_wall)) // Check if will hit wall upon moving
{
    //Check if collision still happens with different slopes
    yCheck = 0;//current slope being checked
    yCheckMax = -10;//max slope allowable
    slopeCheck = true;//whether there is still ground in the way
    while(slopeCheck && yCheck >= yCheckMax){//check through slopes
        yCheck -= 1;
        slopeCheck = place_meeting(x+hsp_final, y+yCheck, obj_wall);
    }
    if(!slopeCheck && place_meeting(x,y-yCheck, obj_wall)){//if a climable slope, move up to meet the ground
        y += yCheck;
    }else{
        while (!place_meeting(x+sign(hsp_final), y, obj_wall)) // Move 1 in current direction until further movement would collide with the wall
        {
            x += sign(hsp_final);
        }
        hsp = 0; // Prevent further horizontal movement on this step
        hsp_final = 0; // Prevent further horizontal movement on this step
    }
}

// Perform horizontal movement
x += hsp_final;

// Slow vertical movement when jump button is released
if (keyboard_check_released(key_jump) && !sign(vsp))
{
    vsp /= 2;
}
// If gliding, slow vertical movement by the glide multiplier
if (gliding && !(vsp <= maxfallspeed * glidemult))
{
    vsp = maxfallspeed * glidemult;
}else{ // If not gliding, and falling, increase gravity
    if (vsp > apexFallTrigger) && (vsp <= maxfallspeed)
    {
        vsp += grav * 2;
    }
}

/*
if (gliding && !(vsp <= maxfallspeed * glidemult))
    vsp = maxfallspeed * glidemult;
*/

vsp_final = vsp + vsp_carry;
vsp_carry = 0;

// Vertical collision aka don't go through the floor/ceiling
if (place_meeting(x, y+vsp_final, obj_wall)) // Check if will hit floor/ceiling upon moving
{
    while (!place_meeting(x, y+sign(vsp_final), obj_wall)) // Move 1 in current direction until further movement would collide with the floor/ceiling
    {
        y += sign(vsp_final);
    }
    vsp = 0; // Prevent further vertical movement on this step
    vsp_final = 0; // Prevent further vertical movement on this step
}

y += vsp_final; // Perform vertical movement

