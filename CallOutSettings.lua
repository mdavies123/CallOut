CallOutSettings = CallOutSettings or {
  Enabled = true,
  
  Targets = {
    target = true, 
    arena1 = true, 
    arena2 = true, 
    arena3 = true, 
    arena4 = true, 
    arena5 = true
  },
  
  SpellIDs = {
    [585]   = {Enabled = true, InstantCast = false},
    [47549] = {Enabled = true, InstantCast = false}, 
    [17]    = {Enabled = true, InstantCast = true}
  },
  
  SoundChannel = "Master"
}