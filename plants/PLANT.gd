extends Resource


class_name plant

export (String) var plant_name
export (Texture) var plant_sprite
export (Texture) var seed_sprite
export (String) var plant_type = "plant"
export (Array, Resource) var other_drops
export (Array, Resource) var rare_drops

export (float) var others_drop_chance
export (int) var max_others_dropped
export (bool) var drops_seed = true
export (int) var max_own_seeds_dropped = 1
export (int) var min_own_seeds_dropped = 1
export (float) var seed_drop_chance
export (int) var growing_time
export (int) var clicks_to_harvest
export (float) var downtime
export (int) var gold_dropped = 1
export (int) var essence_dropped = 0

# variables about nurturing
export (int) var nurture_threshold = 0
export (float) var nurture_multiplier = 1
export (int) var rare_seeds_dropped_if_nurtured = 0
export (float) var rare_seed_drop_chance
