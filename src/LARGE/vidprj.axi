/* -------------------------------------------------------------------------- */
program_name = 'vidprj'
/* -------------------------------------------------------------------------- */
// SECTION PJLINK VIDEO PROJECTOR
/* -------------------------------------------------------------------------- */
define_device
DV_VIDPRJ_01 = 0:50:0
VDV_VIDPRJ_01 = 35050:1:0
/* -------------------------------------------------------------------------- */
define_constant
VIDPRJ_01_IP[] = '192.168.0.50'
/* -------------------------------------------------------------------------- */
define_variable
volatile integer vidprjOnline
volatile integer vidprjPower
volatile integer vidprjMute
integer vidprjLampTime
/* -------------------------------------------------------------------------- */
define_start {
	
}
/* -------------------------------------------------------------------------- */
define_module
'module_pjlink_rev' vidprj1(VDV_VIDPRJ_01, DV_VIDPRJ_01)
/* -------------------------------------------------------------------------- */
define_function vidprj_power_on() {
	send_command VDV_VIDPRJ_01, "'POWER-ON'"
}
define_function vidprj_power_off() {
	send_command VDV_VIDPRJ_01, "'POWER-OFF'"
}
define_function vidprj_mute() {
	send_command VDV_VIDPRJ_01, "'VMUTE-ON'"
}
define_function vidprj_unmute() {
	send_command VDV_VIDPRJ_01, "'VMUTE-OFF'"
}
/* -------------------------------------------------------------------------- */
define_event
data_event[VDV_VIDPRJ_01] {
	online: {
		send_command data.device, "'PROPERTY-IP,', VIDPRJ_01_IP"
	}
}
/* -------------------------------------------------------------------------- */
define_event
timeline_event[TLID_CONTROL_UPDATE] {
	vidprjPower = ch_get(VDV_VIDPRJ_01, 255)
	vidprjMute = ch_get(VDV_VIDPRJ_01, 211)
}
/* -------------------------------------------------------------------------- */
define_device
TP_10001_VIDPRJ = 10001:5:0
/* -------------------------------------------------------------------------- */
define_constant
dev TP_VIDPRJ[NUM_TP] = { TP_10001_VIDPRJ }
/* -------------------------------------------------------------------------- */
// SECTION TP PORT 5 PJLINK VIDEO PROJECTOR
/* -------------------------------------------------------------------------- */
define_event
button_event[TP_VIDPRJ, 21] {
	push: {
		vidprj_power_on()
	}
}
define_event
button_event[TP_VIDPRJ, 22] {
	push: {
		vidprj_power_off()
	}
}
define_event
button_event[TP_VIDPRJ, 23] {
	push: {
		vidprj_mute()
	}
}
define_event
button_event[TP_VIDPRJ, 24] {
	push: {
		vidprj_unmute()
	}
}
/* -------------------------------------------------------------------------- */
define_function ui_refresh_vidprj_power() {
	tp_set_btn_ss(TP_VIDPRJ, 21, vidprjPower)
	tp_set_btn_ss(TP_VIDPRJ, 22, !vidprjPower)
}
define_function ui_refresh_vidprj_mute() {
	tp_set_btn_ss(TP_VIDPRJ, 23, vidprjMute)
	tp_set_btn_ss(TP_VIDPRJ, 24, !vidprjMute)
}
/* -------------------------------------------------------------------------- */
define_event
channel_event[VDV_VIDPRJ_01, 255] {
	on: {
		vidprjPower = true
		ui_refresh_vidprj_power()
	}
	off: {
		vidprjPower = false
		ui_refresh_vidprj_power()
	}
}
define_event
channel_event[VDV_VIDPRJ_01, 211] {
	on: {
		vidprjMute = true
		ui_refresh_vidprj_mute()
	}
	off: {
		vidprjMute = false
		ui_refresh_vidprj_mute()
	}
}
/* -------------------------------------------------------------------------- */
define_event
timeline_event[TLID_UI_UPDATE] {
	ui_refresh_vidprj_power()
	ui_refresh_vidprj_mute()
}
/* -------------------------------------------------------------------------- */
