set_global_assignment -entity "pll_10MHz" -library "lib_pll_10MHz" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "pll_10MHz" -library "lib_pll_10MHz" -name IP_TOOL_VERSION "19.1"
set_global_assignment -entity "pll_10MHz" -library "lib_pll_10MHz" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_pll_10MHz" -name SPD_FILE [file join $::quartus(sip_path) "pll_10MHz.spd"]

set_global_assignment -library "lib_pll_10MHz" -name MISC_FILE [file join $::quartus(sip_path) "pll_10MHz_sim/pll_10MHz.vo"]
