/* -------------------------------------------------------------------------- */
program_name = 'vidrec'
/* -------------------------------------------------------------------------- */
// SECTION BMD HYPERDECK STUDIO
/* -------------------------------------------------------------------------- */
define_device
DV_VIDREC = 0:32:0
/* -------------------------------------------------------------------------- */
define_constant
char VIDREC_IP[15] = '192.168.0.32'
integer VIDREC_PORT = 9993
/* -------------------------------------------------------------------------- */
define_variable
volatile integer vidrecOnline
volatile integer vidrecRecording
volatile char vidrecBuffer[1000]
/* -------------------------------------------------------------------------- */
define_function vidrec_record() {
	send_string DV_VIDREC, "'record', $0D, $0A"
}
define_function vidrec_stop() {
	send_string DV_VIDREC, "'stop', $0D, $0A"
}
define_function vidrec_play() {
	send_string DV_VIDREC, "'play', $0D, $0A"
}
/* -------------------------------------------------------------------------- */
define_function vidrec_parse_response(char temp[]) {
	amx_log(AMX_INFO, "'vidrec_parse_response()', $20, temp")
	if (find_str(temp, "'status: '")) {
		remove_str(temp, "'status: '")
		switch (temp) {
			case 'record': {
				vidrecRecording = 1
			}
			case 'stopped':
			case 'preview': {
				vidrecRecording = 0
			}
			case 'play': {
				vidrecRecording = 2
			}
		}
	}
}
/* -------------------------------------------------------------------------- */
define_start {
	create_buffer DV_VIDREC, vidrecBuffer
	ip_client_open(DV_VIDREC.PORT, VIDREC_IP, VIDREC_PORT, IP_TCP)
}
/* -------------------------------------------------------------------------- */
define_event
data_event[DV_VIDREC] {
	online: {
		vidrecOnline = true
		wait 20 {
			send_string DV_VIDREC, "'remote: enable: true', $0D, $0A"
			wait 20 {
				send_string DV_VIDREC, "'notify: transport: true', $0D, $0A"
			}
		}
	}
	offline: {
		vidrecOnline = false
		wait 50 {
			ip_client_open(DV_VIDREC.PORT, VIDREC_IP, VIDREC_PORT, IP_TCP)
		}
	}
	onerror: {
		vidrecOnline = false
		if (data.number != 9 && data.number != 17) {
			wait 50 {
				ip_client_open(DV_VIDREC.PORT, VIDREC_IP, VIDREC_PORT, IP_TCP)
			}
		}
	}
	string: {
		while (find_str(vidrecBuffer, "$0D, $0A")) {
			vidrec_parse_response(remove_str_strip_chars(vidrecBuffer, "$0D, $0A"))
		}
	}
}
/* -------------------------------------------------------------------------- */
// SECTION TP PORT 4 BMD HYPERDECK STUDIO
/* -------------------------------------------------------------------------- */
define_device
TP_10001_VIDREC = 10001:4:0
/* -------------------------------------------------------------------------- */
define_constant
dev TP_VIDREC[NUM_TP] = { TP_10001_VIDREC }
/* -------------------------------------------------------------------------- */
define_event
button_event[TP_VIDREC, 101] {
	push: {
		vidrec_record()
	}
	release:{
		ui_refresh_vidrec()
	}
}
define_event
button_event[TP_VIDREC, 102] {
	push: {
		vidrec_stop()
	}
	release:{
		ui_refresh_vidrec()
	}
}
define_event
button_event[TP_VIDREC, 103] {
	push: {
		vidrec_play()
	}
	release:{
		ui_refresh_vidrec()
	}
}
/* -------------------------------------------------------------------------- */
define_function ui_refresh_vidrec() {
	tp_set_btn_ss(TP_VIDREC, 101, vidrecRecording == 1)
	tp_set_btn_ss(TP_VIDREC, 102, vidrecRecording == 0)
	tp_set_btn_ss(TP_VIDREC, 103, vidrecRecording == 2)
}
/* -------------------------------------------------------------------------- */
define_event
timeline_event[TLID_UI_UPDATE] {
	ui_refresh_vidrec()
}
/* -------------------------------------------------------------------------- */
