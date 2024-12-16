/* -------------------------------------------------------------------------- */
program_name = 'vidmtx'
/* -------------------------------------------------------------------------- */
// SECTION RTCOM VIDEO MATRIX
/* -------------------------------------------------------------------------- */
define_variable
volatile integer logVidmtx
/* -------------------------------------------------------------------------- */
define_function log_video(char msg[]) { if (logVidmtx) { send_string 0, "'log_video >> ', msg" } }
/* -------------------------------------------------------------------------- */
define_device DV_VIDMTX = 5001:2:0
/* -------------------------------------------------------------------------- */
define_constant
integer NUM_VIDMTX_IN = 16
integer NUM_VIDMTX_OUT = 16
/* -------------------------------------------------------------------------- */
define_variable
persistent integer vidmtxRoutes[NUM_VIDMTX_OUT]
volatile char vidmtxCommandBuffer[2000]
/* -------------------------------------------------------------------------- */
define_constant
long TLID_VIDEO_POLL = 500102
/* -------------------------------------------------------------------------- */
define_variable
volatile long TLT_VIDEO_POLL[] = {200}
/* -------------------------------------------------------------------------- */
define_function vidmtx_switch(integer in, integer out) {
	log_video("'vidmtx_switch() :: in=', itoa(in), ' out=', itoa(out)");
	send_string DV_VIDMTX, "'*255CI', format('%03d', in), 'O', format('%03d', out), '!'"
	vidmtxRoutes[out] = in
}
define_function vidmtx_add_command(integer in, integer out) {
	vidmtxCommandBuffer = "vidmtxCommandBuffer, 'CI', itoa(in), 'O', itoa(out), $0D"
}
/* -------------------------------------------------------------------------- */
define_event
data_event[DV_VIDMTX] {
	online: {
		clear_buffer vidmtxCommandBuffer
		send_command data.device, "'SET BAUD 19200 N,8,1'"
		timeline_add(TLID_VIDEO_POLL, TLT_VIDEO_POLL, TIMELINE_RELATIVE, TIMELINE_REPEAT, true)
	}
}
/* -------------------------------------------------------------------------- */
define_event
timeline_event[TLID_VIDEO_POLL] {
	char temp[100]
	integer in, out
	if (find_str(vidmtxCommandBuffer, "$0D")) {
		temp = remove_str_strip_chars(vidmtxCommandBuffer, "$0D")
		remove_str(temp, 'CI')
		in = atoi(remove_str_strip_chars(temp, 'O'))
		out = atoi(temp)
		vidmtx_switch(in, out)
	}
}
/* -------------------------------------------------------------------------- */
// SECTION TP PORT 6 RTCOM VIDEO MATRIX
/* -------------------------------------------------------------------------- */
define_device
TP_10001_VIDMTX = 10001:6:0
/* -------------------------------------------------------------------------- */
define_constant
dev TP_VIDMTX[NUM_TP] = { TP_10001_VIDMTX }
/* -------------------------------------------------------------------------- */
define_variable
volatile integer vidmtxSelectedInput[NUM_TP]
/* -------------------------------------------------------------------------- */
define_event
button_event[TP_VIDMTX, 0] {
	push: {
		integer index_button
		integer index_tp
		index_button = button.input.channel
		index_tp = get_last(TP_VIDMTX)
		select {
			active (is_range(index_button, 101, 101 + NUM_VIDMTX_IN)): {
				select_index(vidmtxSelectedInput[index_tp], index_button - 100, false)
				ui_refresh_vidmtx_selected_input()
				ui_refresh_vidmtx_routes()
			}
			active (is_range(index_button, 151, 151 + NUM_VIDMTX_OUT)): {
				integer in, out
				in = vidmtxSelectedInput[index_tp]
				out = index_button - 150
				if (in == vidmtxRoutes[out]) {
					vidmtx_add_command(0, out)
				}
				else {
					vidmtx_add_command(in, out)
				}
				ui_refresh_vidmtx_routes()
			}
		}
	}
}
/* -------------------------------------------------------------------------- */
define_function ui_refresh_vidmtx_selected_input() {
	integer i
	for (i = 1; i <= NUM_TP; i++) {
		tp_set_btn_in_range(TP_VIDMTX[i], 101, NUM_VIDMTX_IN, vidmtxSelectedInput[i])
	}
}
define_function ui_refresh_vidmtx_routes() {
	integer i, j
	for (j = 1; j <= NUM_TP; j++) {
		if (vidmtxSelectedInput[j]) {
			for (i = 1; i <= NUM_VIDMTX_OUT; i++) {
				tp_set_btn(TP_VIDMTX[j], 150 + i, vidmtxRoutes[i] == vidmtxSelectedInput[j])
			}
		}
		else {
			tp_set_btn_in_range(TP_VIDMTX[j], 150, NUM_VIDMTX_OUT, false)
		}
	}
}
/* -------------------------------------------------------------------------- */
define_event
timeline_event[TLID_UI_UPDATE] {
	ui_refresh_vidmtx_selected_input()
	ui_refresh_vidmtx_routes()
}
/* -------------------------------------------------------------------------- */
