set_global_assignment -entity "pll_391" -library "lib_pll_391" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "pll_391" -library "lib_pll_391" -name IP_TOOL_VERSION "19.1"
set_global_assignment -entity "pll_391" -library "lib_pll_391" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_pll_391" -name SPD_FILE [file join $::quartus(sip_path) "pll_391.spd"]

set_global_assignment -library "lib_pll_391" -name MISC_FILE [file join $::quartus(sip_path) "pll_391_sim/pll_391.vo"]
