// Sets music to close
if audio_sound_get_track_position(sndMusic) < endStart
{
    audio_sound_set_track_position(sndMusic, endStart);
}
