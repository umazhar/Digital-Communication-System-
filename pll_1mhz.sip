set_global_assignment -entity "pll_1mhz" -library "lib_pll_1mhz" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "pll_1mhz" -library "lib_pll_1mhz" -name IP_TOOL_VERSION "19.1"
set_global_assignment -entity "pll_1mhz" -library "lib_pll_1mhz" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_pll_1mhz" -name SPD_FILE [file join $::quartus(sip_path) "pll_1mhz.spd"]

set_global_assignment -library "lib_pll_1mhz" -name MISC_FILE [file join $::quartus(sip_path) "pll_1mhz_sim/pll_1mhz.vo"]
