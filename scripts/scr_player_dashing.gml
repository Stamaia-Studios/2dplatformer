scr_player_movement();

if dashAttackTimer == dashAttackCool
{
    dashDir = move;
    instance_create(x+((sprite_width*1.5)*dashDir), y, obj_hb_dash);//create the dash attack hitbox object
    dashAttackTimer = 0;//dash attack cool down reset
    attackState = 1;//is attacking
    hsp += (dashDir * 15);
    sprite_index = spr_player_dash;
    currState = state.normal;
}
