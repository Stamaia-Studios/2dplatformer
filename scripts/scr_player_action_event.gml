// action button event handler, pick up action takes priority over throws
if (action_pressed)
{
    // If pick up conditions are met then pick up object that character is on top of

    // power ups can be picked up even if carrying a throwable
    // for now health is considered to be an automatic pickup
    if (pick_up_ok && place_meeting(x, y, obj_gloves) && !has_gloves) 
    {
       
        // get the object ID - rect bounding box
        object_id = collision_rectangle(x-chrW, y-chrH, x+chrW, y+chrH, obj_gloves, false, true);
     
        // stop any movement
        vsp = 0;    
        hsp = 0;        
       
        has_gloves = true; // attacks are now more powerful
        
        // tell object to disappear
        object_id.is_taken = true;
    }
    else if (pick_up_ok && place_meeting(x, y, obj_shorts) && !has_shorts) 
    {
    
        // get the object ID - rect bounding box
        object_id = collision_rectangle(x-chrW, y-chrH, x+chrW, y+chrH, obj_shorts, false, true);
    
        // stop any movement
        vsp = 0;    
        hsp = 0;
        
        // present but will have no effect on play
        has_shorts = true; // jumps higher, runs faster
        
        // tell object to disappear
        object_id.is_taken = true;
    }
    
    else if (pick_up_ok && place_meeting(x, y, obj_boomerang) && !has_boomerang) 
    {
    
        // get the object ID - rect bounding box
        object_id = collision_rectangle(x-chrW, y-chrH, x+chrW, y+chrH, obj_boomerang, false, true);
        
        // stop any movement
        vsp = 0;    
        hsp = 0;
                
        has_boomerang = true; // throwable object that can be reused if caught        
               
        // tell object to disappear
        object_id.is_taken = true;     
    }
    else if (pick_up_ok && place_meeting(x, y, obj_pot) && !has_throwable) 
    {
    
        // get the object ID - rect bounding box
        object_id = collision_rectangle(x-chrW, y-chrH, x+chrW, y+chrH, obj_pot, false, true);
    
        // stop any movement
        vsp = 0;    
        hsp = 0;
       
        has_throwable = true; // throwable item like a pot, can damage enemies

        // get the items id so we can spawn it when throwing it
        throwable_id = object_id.item_id;
        
        // tell object to disappear
        object_id.is_taken = true;      
    }
    else if (pick_up_ok && place_meeting(x, y, obj_rock) && !has_throwable) 
    {
    
        // get the object ID - rect bounding box
        object_id = collision_rectangle(x-chrW, y-chrH, x+chrW, y+chrH, obj_rock, false, true);
    
        // stop any movement
        vsp = 0;    
        hsp = 0;
       
        has_throwable = true; 
            
        // get the items id so we can spawn it when throwing it
        throwable_id = object_id.item_id;
        
        // tell object to disappear
        object_id.is_taken = true;      
    }                   
    else if (pick_up_ok && pWall_pickup_chk && !has_throwable) 
    {
    
        // get the object ID - rect bounding box
        object_id = collision_rectangle(x-(chrW*1.5), y-(chrH*1.5), x+(chrW*1.5), y+(chrH*1.5), obj_pWall, false, true);
    
        // stop any movement
        vsp = 0;    
        hsp = 0;
       
        has_throwable = true; // throwable item like a pot, can damage enemies

        // get the items id so we can spawn it when throwing it
        throwable_id = object_id.item_id;
        
        // tell object to disappear
        object_id.is_taken = true;      
    }  // end of pick up actions               

    
    // throw action
    else if (throw_ok) {
        
        // pots (wide sine and destroy), rocks (short sine and destroy), and walls (normal sine and plop)
        // create an instance of the object based on id and then tell it to propel across game screen
        if (has_throwable) {
            
            // pot
            if (throwable_id == 1) {
                object_id = instance_create(x, y-(chrH*2), obj_pot);
                object_id.throwDir = facingDir;
                object_id.is_thrown = true;                
            }
            // rock
            else if (throwable_id == 2) {
                object_id = instance_create(x, y-(chrH*2), obj_rock);
                object_id.throwDir = facingDir;
                object_id.is_thrown = true;    
            }
            // wall - they never die and can respawn
            else if (throwable_id == 3) {
                object_id = instance_create(x, y-(chrH*2), obj_pWall);
                object_id.throwDir = facingDir;
                object_id.is_thrown = true;   
            }
            
            // player used throwable remove it from inventory
            throwable_id = 0;
            has_throwable = false;        
        }
        // boomerangs are straight throw and always come back
        else if (has_boomerang) {
            object_id = instance_create(x, y, obj_boomerang);
            object_id.throwDir = facingDir;
            object_id.is_thrown = true;
            has_boomerang = false;
        }    
    }
}

// pick up condition - set flag high if conditions met (idle, moving, running only)
pick_up_ok = onground && (running || move || move == 0) && !down_pressed && !dashtrigger && !attackTrigger;
pWall_pickup_chk = place_meeting(x, y+1, obj_pWall) | place_meeting(x, y-1, obj_pWall) | place_meeting(x+1, y, obj_pWall) | place_meeting(x-1, y, obj_pWall);
