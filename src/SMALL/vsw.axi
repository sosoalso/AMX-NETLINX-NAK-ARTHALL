/* -------------------------------------------------------------------------- */
program_name = 'vsw'
/* -------------------------------------------------------------------------- */
// SECTION ATEM VIDEO SWITCHER
/* -------------------------------------------------------------------------- */
define_device
DV_ATEM = 0:41:0
/* -------------------------------------------------------------------------- */
define_variable
char ATEM_IP[] = '192.168.0.41'
/* -------------------------------------------------------------------------- */
#include 'lib_dev_atem_switcher'
/* -------------------------------------------------------------------------- */
define_start {
	wait 30 {
		atemAutoConnect = true
		atem_connect()
	}
}
/* -------------------------------------------------------------------------- */
// SECTION TP PORT 3 ATEM VIDEO SWITCHER
/* -------------------------------------------------------------------------- */
define_device
TP_10001_VSW = 10001:3:0
/* -------------------------------------------------------------------------- */
define_constant
dev TP_VSW[NUM_TP] = { TP_10001_VSW }
/* -------------------------------------------------------------------------- */
define_event
button_event[TP_VSW, 201]
button_event[TP_VSW, 202]
button_event[TP_VSW, 203]
button_event[TP_VSW, 204]
button_event[TP_VSW, 205]
button_event[TP_VSW, 206]
button_event[TP_VSW, 207]
button_event[TP_VSW, 208] {
	push: {
		integer index
		index = button.input.channel - 200
		atem_set_program_input_video_source(index)
	}
	release: {
		ui_refresh_vsw_switch_pgm()
	}
}
/* -------------------------------------------------------------------------- */
define_function ui_refresh_vsw_switch_pgm() {
	tp_set_btn_in_range_ss(TP_VSW, 201, 8, atemCurrentProgramInput)
}
/* -------------------------------------------------------------------------- */
define_event timeline_event[TLID_UI_UPDATE] {
	ui_refresh_vsw_switch_pgm()
}
/* -------------------------------------------------------------------------- */
