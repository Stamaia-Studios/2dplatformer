// Repeat music from repeat point
if audio_sound_get_track_position(sndMusic) >= loopEnd
{
    audio_sound_set_track_position(sndMusic, loopStart);
}
