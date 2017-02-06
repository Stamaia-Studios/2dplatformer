if ((keyboard_check_released(key_down) || onground) && fallthrough) // If in fallthrough and down key has been released or have touched ground, exit fallthrough
    fallthrough = false;
    currState = state.normal;
