tool
extends Screen
class_name SettingsScreen

const TYPE := ScreenType.SETTINGS
const INCLUDES_STANDARD_HIERARCHY := true
const INCLUDES_NAV_BAR := true
const INCLUDES_CENTER_CONTAINER := true

# Array<Dictionary>
var main_items := [
    {
        label = "Difficulty",
        type = LabeledControlItemType.DROPDOWN,
        options = [
            DifficultyMode.get_modified_type_string(DifficultyMode.EASY),
            DifficultyMode.get_modified_type_string(DifficultyMode.MODERATE),
            DifficultyMode.get_modified_type_string(DifficultyMode.HARD),
        ],
        description = \
                "The player moves faster at higher difficulties." + \
                "\n\nOn Hard, levels end after one loop." + \
                "\n\nOn Harder and Hardest, levels loop until you run out of lives." + \
                "\n\nOn Hard, you have infinite lives." + \
                "\n\nOn Hardest, extra lives do not appear." + \
                "\n\nYour score is increased with higher difficulties." + \
                "\n\nIt may not be possible to get Silver or Gold ranks on Hard.",
    },
    {
        label = "Control version",
        type = LabeledControlItemType.DROPDOWN,
        options = [
            "1R",
            "1L",
            "2R",
            "2L",
            "3R",
            "3L",
            "4",
        ],
        description = \
                "1R: Left-side tap to jump. Right-side drag to move " + \
                        "sideways. Input is based on total drag movement " + \
                        "since any drag movement in the other direction." + \
                "\n\n1L: Same as 1R, but with jump input on right side " + \
                        "and sideways input on left side." + \
                "\n\n2R: Same as 1R, but sideways movement is based on " + \
                        "recend drag speed." + \
                "\n\n2L: Same as 1L, but sideways movement is based on " + \
                        "recend drag speed." + \
                "\n\n3R: Left-side tap to jump. Right-side drag to move " + \
                        "sideways. Input is based on drag movement " + \
                        "relative to initial touch position." + \
                "\n\n3L: Same as 3R, but with jump input on right side " + \
                        "and sideways input on left side." + \
                "\n\n4: One-handed control. Drag up to jump. Drag " + \
                        "sideways to move sideways.",
    },
    {
        label = "Music",
        type = LabeledControlItemType.CHECKBOX,
    },
    {
        label = "Sound effects",
        type = LabeledControlItemType.CHECKBOX,
    },
    {
        label = "Haptic feedback",
        type = LabeledControlItemType.CHECKBOX,
    },
]

# Array<Dictionary>
var details_items := [
    {
        label = "Multiplier cooldown indicator",
        type = LabeledControlItemType.CHECKBOX,
    },
    {
        label = "Height indicator",
        type = LabeledControlItemType.CHECKBOX,
    },
    {
        label = "Control display",
        type = LabeledControlItemType.CHECKBOX,
    },
    {
        label = "Score display",
        type = LabeledControlItemType.CHECKBOX,
    },
    {
        label = "Next-rank-at display",
        type = LabeledControlItemType.CHECKBOX,
    },
    {
        label = "Lives display",
        type = LabeledControlItemType.CHECKBOX,
    },
    {
        label = "Time display",
        type = LabeledControlItemType.CHECKBOX,
    },
    {
        label = "Height display",
        type = LabeledControlItemType.CHECKBOX,
    },
    {
        label = "Tier ratio display",
        type = LabeledControlItemType.CHECKBOX,
    },
    {
        label = "Multiplier display",
        type = LabeledControlItemType.CHECKBOX,
    },
    {
        label = "Speed display",
        type = LabeledControlItemType.CHECKBOX,
    },
    {
        label = "Debug time display",
        type = LabeledControlItemType.CHECKBOX,
    },
    {
        label = "Debug panel",
        type = LabeledControlItemType.CHECKBOX,
    },
]

var _main_list: LabeledControlList
var _details_list: LabeledControlList

func _init().( \
        TYPE, \
        INCLUDES_STANDARD_HIERARCHY, \
        INCLUDES_NAV_BAR, \
        INCLUDES_CENTER_CONTAINER \
        ) -> void:
    pass

func _ready() -> void:
    _main_list = $FullScreenPanel/VBoxContainer/CenteredPanel/ \
            ScrollContainer/CenterContainer/VBoxContainer/MainList
    _details_list = $FullScreenPanel/VBoxContainer/CenteredPanel/ \
            ScrollContainer/CenterContainer/VBoxContainer/AccordionPanel/ \
            VBoxContainer/DetailsList
    _main_list.connect( \
            "control_changed", \
            self, \
            "_on_control_changed", \
            [true])
    _details_list.connect( \
            "control_changed", \
            self, \
            "_on_control_changed", \
            [false])
    _main_list.items = main_items
    _details_list.items = details_items

func _on_activated() -> void:
    ._on_activated()
    _initialize_selections()
    _initialize_enablement()
    _main_list.items = main_items
    _details_list.items = details_items

func _on_deactivated() -> void:
    if Global.level != null:
        Nav.screens[ScreenType.GAME].restart_level()

func _initialize_selections() -> void:
    var difficulty_item: Dictionary = \
            _main_list.find_item("Difficulty")
    for i in range(difficulty_item.options.size()):
        if difficulty_item.options[i] == \
                DifficultyMode.get_modified_type_string(Global.difficulty_mode):
            difficulty_item.selected_index = i
            break
    
    var control_version_item: Dictionary = \
            _main_list.find_item("Control version")
    for i in range(control_version_item.options.size()):
        if control_version_item.options[i] == \
                str(Global.mobile_control_version):
            control_version_item.selected_index = i
            break
    
    _main_list.find_item("Haptic feedback").pressed = \
            Global.is_giving_haptic_feedback
    _details_list.find_item("Debug panel").pressed = \
            Global.is_debug_panel_shown
    _details_list.find_item("Control display").pressed = \
            Global.are_mobile_controls_shown
    
    _details_list.find_item("Multiplier cooldown indicator").pressed = \
            Global.is_multiplier_cooldown_indicator_shown
    _details_list.find_item("Height indicator").pressed = \
            Global.is_height_indicator_shown
    _details_list.find_item("Score display").pressed = \
            Global.is_score_display_shown
    _details_list.find_item("Next-rank-at display").pressed = \
            Global.is_next_rank_at_display_shown
    _details_list.find_item("Height display").pressed = \
            Global.is_height_display_shown
    _details_list.find_item("Lives display").pressed = \
            Global.is_lives_display_shown
    _details_list.find_item("Time display").pressed = \
            Global.is_time_display_shown
    _details_list.find_item("Tier ratio display").pressed = \
            Global.is_tier_ratio_display_shown
    _details_list.find_item("Multiplier display").pressed = \
            Global.is_multiplier_display_shown
    _details_list.find_item("Speed display").pressed = \
            Global.is_speed_display_shown
    _details_list.find_item("Debug time display").pressed = \
            Global.is_debug_time_shown
    
    _main_list.find_item("Music").pressed = \
            Audio.is_music_enabled
    _main_list.find_item("Sound effects").pressed = \
            Audio.is_sound_effects_enabled

func _initialize_enablement() -> void:
    _main_list.find_item("Haptic feedback").disabled = \
            !Utils.get_is_mobile_device()
    
#    var is_level_active := Global.level != null
#    _main_list.find_item("Difficulty").disabled = is_level_active
#    _main_list.find_item("Control version").disabled = is_level_active
    _main_list.find_item("Difficulty").disabled = false
    _main_list.find_item("Control version").disabled = false
    
    _details_list.find_item("Debug panel").disabled = false 
    _details_list.find_item("Control display").disabled = false 
    _details_list.find_item("Multiplier cooldown indicator").disabled = false 
    _details_list.find_item("Height indicator").disabled = false 
    _details_list.find_item("Score display").disabled = false 
    _details_list.find_item("Next-rank-at display").disabled = false 
    _details_list.find_item("Height display").disabled = false 
    _details_list.find_item("Lives display").disabled = false 
    _details_list.find_item("Time display").disabled = false 
    _details_list.find_item("Tier ratio display").disabled = false 
    _details_list.find_item("Multiplier display").disabled = false 
    _details_list.find_item("Speed display").disabled = false 
    _details_list.find_item("Debug time display").disabled = false 
    _main_list.find_item("Music").disabled = false 
    _main_list.find_item("Sound effects").disabled = false 

func _on_control_changed( \
        index: int, \
        is_main: bool) -> void:
    var item: Dictionary = \
            main_items[index] if \
            is_main else \
            details_items[index]
    
    match item.label:
        "Difficulty":
            _on_difficulty_selected( \
                    item.selected_index, \
                    item.options[item.selected_index])
        "Control version":
            _on_mobile_control_version_selected( \
                    item.selected_index, \
                    item.options[item.selected_index])
        "Haptic feedback":
            _on_haptic_feedback_pressed(item.pressed)
        "Debug panel":
            _on_debug_panel_pressed(item.pressed)
        "Control display":
            _on_mobile_control_display_pressed(item.pressed)
        "Multiplier cooldown indicator":
            _on_multiplier_cooldown_indicator_pressed(item.pressed)
        "Height indicator":
            _on_height_indicator_pressed(item.pressed)
        "Score display":
            _on_score_display_pressed(item.pressed)
        "Next-rank-at display":
            _on_next_rank_at_display_pressed(item.pressed)
        "Height display":
            _on_height_display_pressed(item.pressed)
        "Lives display":
            _on_lives_display_pressed(item.pressed)
        "Time display":
            _on_time_display_pressed(item.pressed)
        "Tier ratio display":
            _on_tier_ratio_display_pressed(item.pressed)
        "Multiplier display":
            _on_multiplier_display_pressed(item.pressed)
        "Speed display":
            _on_speed_display_pressed(item.pressed)
        "Debug time display":
            _on_debug_time_display_pressed(item.pressed)
        "Music":
            _on_music_pressed(item.pressed)
        "Sound effects":
            _on_sound_effects_pressed(item.pressed)
        _:
            Utils.error()

func _update_level_displays() -> void:
    if Global.level != null:
        Global.level.update_displays()

func _on_difficulty_selected( \
        option_index: int, \
        option_label: String) -> void:
    Global.difficulty_mode = DifficultyMode.get_modified_string_type(option_label)
    Global.set_setting(SaveState.DIFFICULTY_KEY, Global.difficulty_mode)
    Global.set_selected_difficulty()

func _on_mobile_control_version_selected( \
        option_index: int, \
        option_label: String) -> void:
    Global.mobile_control_version = option_label
    Global.set_setting( \
            SaveState.MOBILE_CONTROL_VERSION_KEY, \
            Global.mobile_control_version)

func _on_haptic_feedback_pressed(pressed: bool) -> void:
    Global.is_giving_haptic_feedback = pressed
    Global.set_setting( \
            SaveState.IS_GIVING_HAPTIC_FEEDBACK_KEY, \
            Global.is_giving_haptic_feedback)

func _on_debug_panel_pressed(pressed: bool) -> void:
    Global.is_debug_panel_shown = pressed
    Global.set_setting( \
            SaveState.IS_DEBUG_PANEL_SHOWN_KEY, \
            Global.is_debug_panel_shown)
    _update_level_displays()

func _on_mobile_control_display_pressed(pressed: bool) -> void:
    Global.are_mobile_controls_shown = pressed
    Global.set_setting( \
            SaveState.ARE_MOBILE_CONTROLS_SHOWN_KEY, \
            Global.are_mobile_controls_shown)
    _update_level_displays()

func _on_multiplier_cooldown_indicator_pressed(pressed: bool) -> void:
    Global.is_multiplier_cooldown_indicator_shown = pressed
    Global.set_setting( \
            SaveState.IS_MULTIPLIER_COOLDOWN_INDICATOR_SHOWN_KEY, \
            Global.is_multiplier_cooldown_indicator_shown)
    _update_level_displays()

func _on_height_indicator_pressed(pressed: bool) -> void:
    Global.is_height_indicator_shown = pressed
    Global.set_setting( \
            SaveState.IS_HEIGHT_INDICATOR_SHOWN_KEY, \
            Global.is_height_indicator_shown)
    _update_level_displays()

func _on_score_display_pressed(pressed: bool) -> void:
    Global.is_score_display_shown = pressed
    Global.set_setting( \
            SaveState.IS_SCORE_DISPLAY_SHOWN_KEY, \
            Global.is_score_display_shown)
    _update_level_displays()

func _on_next_rank_at_display_pressed(pressed: bool) -> void:
    Global.is_next_rank_at_display_shown = pressed
    Global.set_setting( \
            SaveState.IS_NEXT_RANK_AT_DISPLAY_SHOWN_KEY, \
            Global.is_next_rank_at_display_shown)
    _update_level_displays()

func _on_height_display_pressed(pressed: bool) -> void:
    Global.is_height_display_shown = pressed
    Global.set_setting( \
            SaveState.IS_HEIGHT_DISPLAY_SHOWN_KEY, \
            Global.is_height_display_shown)
    _update_level_displays()

func _on_lives_display_pressed(pressed: bool) -> void:
    Global.is_lives_display_shown = pressed
    Global.set_setting( \
            SaveState.IS_LIVES_DISPLAY_SHOWN_KEY, \
            Global.is_lives_display_shown)
    _update_level_displays()

func _on_time_display_pressed(pressed: bool) -> void:
    Global.is_time_display_shown = pressed
    Global.set_setting( \
            SaveState.IS_TIME_DISPLAY_SHOWN_KEY, \
            Global.is_time_display_shown)
    _update_level_displays()

func _on_tier_ratio_display_pressed(pressed: bool) -> void:
    Global.is_tier_ratio_display_shown = pressed
    Global.set_setting( \
            SaveState.IS_TIER_RATIO_DISPLAY_SHOWN_KEY, \
            Global.is_tier_ratio_display_shown)
    _update_level_displays()

func _on_multiplier_display_pressed(pressed: bool) -> void:
    Global.is_multiplier_display_shown = pressed
    Global.set_setting( \
            SaveState.IS_MULTIPLIER_DISPLAY_SHOWN_KEY, \
            Global.is_multiplier_display_shown)
    _update_level_displays()

func _on_speed_display_pressed(pressed: bool) -> void:
    Global.is_speed_display_shown = pressed
    Global.set_setting( \
            SaveState.IS_SPEED_DISPLAY_SHOWN_KEY, \
            Global.is_speed_display_shown)
    _update_level_displays()

func _on_debug_time_display_pressed(pressed: bool) -> void:
    Global.is_debug_time_shown = pressed
    Global.set_setting( \
            SaveState.IS_DEBUG_TIME_DISPLAY_SHOWN_KEY, \
            Global.is_debug_time_shown)
    _update_level_displays()

func _on_music_pressed(pressed: bool):
    Audio.is_music_enabled = pressed
    Global.set_setting( \
            SaveState.IS_MUSIC_ENABLED_KEY, \
            Audio.is_music_enabled)

func _on_sound_effects_pressed(pressed: bool):
    Audio.is_sound_effects_enabled = pressed
    Global.set_setting( \
            SaveState.IS_SOUND_EFFECTS_ENABLED_KEY, \
            Audio.is_sound_effects_enabled)
