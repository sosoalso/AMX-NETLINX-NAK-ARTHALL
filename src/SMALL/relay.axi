/* -------------------------------------------------------------------------- */
program_name = 'relay'
/* -------------------------------------------------------------------------- */
// SECTION TP PORT 10 RELAY
/* -------------------------------------------------------------------------- */
define_variable
volatile integer logRelay
/* -------------------------------------------------------------------------- */
define_function log_relay(char msg[]) { if (logRelay) { amx_log(AMX_INFO, "'log_relay >> ', msg") } }
/* -------------------------------------------------------------------------- */
define_constant
integer NUM_RELAY = 32
/* -------------------------------------------------------------------------- */
define_device
DV_RELAY_01 = 5001:21:0
DV_RELAY_02 = 6001:1:0
DV_RELAY_03 = 6002:1:0
DV_RELAY_04 = 6003:1:0
/* -------------------------------------------------------------------------- */
define_constant
devchan DC_RELAYS[NUM_RELAY] = {
	{DV_RELAY_01, 1},
	{DV_RELAY_01, 2},
	{DV_RELAY_01, 3},
	{DV_RELAY_01, 4},
	{DV_RELAY_01, 5},
	{DV_RELAY_01, 6},
	{DV_RELAY_01, 7},
	{DV_RELAY_01, 8},
	{DV_RELAY_02, 1},
	{DV_RELAY_02, 2},
	{DV_RELAY_02, 3},
	{DV_RELAY_02, 4},
	{DV_RELAY_02, 5},
	{DV_RELAY_02, 6},
	{DV_RELAY_02, 7},
	{DV_RELAY_02, 8},
	{DV_RELAY_03, 1},
	{DV_RELAY_03, 2},
	{DV_RELAY_03, 3},
	{DV_RELAY_03, 4},
	{DV_RELAY_03, 5},
	{DV_RELAY_03, 6},
	{DV_RELAY_03, 7},
	{DV_RELAY_03, 8},
	{DV_RELAY_04, 1},
	{DV_RELAY_04, 2},
	{DV_RELAY_04, 3},
	{DV_RELAY_04, 4},
	{DV_RELAY_04, 5},
	{DV_RELAY_04, 6},
	{DV_RELAY_04, 7},
	{DV_RELAY_04, 8}
}
/* -------------------------------------------------------------------------- */
define_function relay_on(integer d) {
	if (is_range(d, 1, NUM_RELAY)) {
		dc_on(DC_RELAYS[d])
		log_relay("'relay_on() :: d=', itoa(d)")
	}
}
define_function relay_off(integer d) {
	if (is_range(d, 1, NUM_RELAY)) {
		dc_off(DC_RELAYS[d])
		log_relay("'relay_off() :: d=', itoa(d)")
	}
}
define_function relay_pulse(integer d, integer pulsetime) {
	if (is_range(d, 1, NUM_RELAY)) {
		dc_pulse(DC_RELAYS[d], pulsetime)
		log_relay("'relay_pulse() :: d=', itoa(d)")
	}
}
/* -------------------------------------------------------------------------- */
// SECTION TP PORT 10 RELAY
/* -------------------------------------------------------------------------- */
define_device
TP_10001_RELAY = 10001:10:0
/* -------------------------------------------------------------------------- */
define_constant
dev TP_RELAY[NUM_TP] = { TP_10001_RELAY }
/* -------------------------------------------------------------------------- */
define_event
button_event[TP_RELAY, 0] {
	push: {
		integer button_index
		integer ch_index
		button_index = button.input.channel
		/* -------------------------------------------------------------------------- */
		if (is_range(button_index, 1, NUM_RELAY)) {
			ch_index = button_index
			relay_pulse(ch_index, 5)
		}
		if (is_range(button_index, 51, 50 + NUM_RELAY)) {
			ch_index = button_index - 50
			relay_on(ch_index)
			ui_refresh_relay(ch_index)
		}
		if (is_range(button_index, 101, 100 + NUM_RELAY)) {
			ch_index = button_index - 100
			relay_off(ch_index - 100)
			ui_refresh_relay(ch_index)
		}
	}
}
/* -------------------------------------------------------------------------- */
define_function ui_refresh_relay(integer ch_index) {
	if (!ch_index) {
		integer i
		for (i = 1; i <= NUM_RELAY; i++) {
			ui_refresh_relay(i)
		}
		return
	}
	else if (is_range(ch_index, 1, NUM_RELAY)) {
		tp_set_btn_ss(TP_RELAY, ch_index + 50, dc_get(DC_RELAYS[ch_index]))
		tp_set_btn_ss(TP_RELAY, ch_index + 100, !dc_get(DC_RELAYS[ch_index]))
	}
}
/* -------------------------------------------------------------------------- */
define_event
timeline_event[TLID_UI_UPDATE] {
	ui_refresh_relay(0)
}
/* -------------------------------------------------------------------------- */
