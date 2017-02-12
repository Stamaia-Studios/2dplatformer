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


