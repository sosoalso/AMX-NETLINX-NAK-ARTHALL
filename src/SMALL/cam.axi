/* -------------------------------------------------------------------------- */
program_name = 'cam'
/* -------------------------------------------------------------------------- */
// SECTION PANASONIC CAMERA
/* -------------------------------------------------------------------------- */
define_variable
volatile integer logCam
/* -------------------------------------------------------------------------- */
define_function log_cam(char msg[]) { if (logCam) { amx_log(AMX_INFO, "'log_cam >> ', msg") } }
/* -------------------------------------------------------------------------- */
define_constant
integer PANA_CAM_SPD_FAST = 24
integer PANA_CAM_SPD_SLOW = 12
integer NUM_CAM = 4
char IP_PANA_CAM[NUM_CAM][15] = {
	'192.168.0.31',
	'192.168.0.32',
	'192.168.0.33',
	'192.168.0.34'
}
/* -------------------------------------------------------------------------- */
define_variable
persistent integer camSpeed
/* -------------------------------------------------------------------------- */
#include 'lib_pana_ptz_http'
/* -------------------------------------------------------------------------- */
define_function cam_set_speed(integer bool) {
	log_cam("'cam_set_speed() :: bool=', itoa(bool)")
	camSpeed = bool
}
define_function cam_move_up(integer cam_index) {
	log_cam("'cam_move_up() :: cam_index=', itoa(cam_index)")
	pana_ptz_move_up(IP_PANA_CAM[cam_index], camSpeed)
}
define_function cam_move_down(integer cam_index) {
	log_cam("'cam_move_down() :: cam_index=', itoa(cam_index)")
	pana_ptz_move_down(IP_PANA_CAM[cam_index], camSpeed)
}
define_function cam_move_left(integer cam_index) {
	log_cam("'cam_move_left() :: cam_index=', itoa(cam_index)")
	pana_ptz_move_left(IP_PANA_CAM[cam_index], camSpeed)
}
define_function cam_move_right(integer cam_index) {
	log_cam("'cam_move_right() :: cam_index=', itoa(cam_index)")
	pana_ptz_move_right(IP_PANA_CAM[cam_index], camSpeed)
}
define_function cam_zoom_in(integer cam_index) {
	log_cam("'cam_zoom_in() :: cam_index=', itoa(cam_index)")
	pana_ptz_zoom_in(IP_PANA_CAM[cam_index], camSpeed)
}
define_function cam_zoom_out(integer cam_index) {
	log_cam("'cam_zoom_out() :: cam_index=', itoa(cam_index)")
	pana_ptz_zoom_out(IP_PANA_CAM[cam_index], camSpeed)
}
define_function cam_stop_move(integer cam_index) {
	log_cam("'cam_stop_move() :: cam_index=', itoa(cam_index)")
	pana_ptz_move_stop(IP_PANA_CAM[cam_index])
}
define_function cam_stop_zoom(integer cam_index) {
	log_cam("'cam_stop_zoom() :: cam_index=', itoa(cam_index)")
	pana_ptz_zoom_stop(IP_PANA_CAM[cam_index])
}
define_function cam_recall_preset(integer cam_index, integer pno) {
	log_cam("'cam_recall_preset() :: cam_index=', itoa(cam_index), ' pno=', itoa(pno)")
	pana_ptz_recall_preset(IP_PANA_CAM[cam_index], pno)
}
define_function cam_store_preset(integer cam_index, integer pno) {
	log_cam("'cam_store_preset() :: cam_index=', itoa(cam_index), ' pno=', itoa(pno)")
	pana_ptz_store_preset(IP_PANA_CAM[cam_index], pno)
}
/* -------------------------------------------------------------------------- */
// SECTION TP PORT 2 PANASONIC CAMERA
/* -------------------------------------------------------------------------- */
define_device
TP_10001_CAM = 10001:2:0
/* -------------------------------------------------------------------------- */
define_constant
dev TP_CAM[NUM_TP] = { TP_10001_CAM }
/* -------------------------------------------------------------------------- */
define_variable
volatile integer camLastRecallPreset[NUM_CAM]
volatile integer camSelected[NUM_TP]
volatile integer camStoreMode[NUM_TP]
/* -------------------------------------------------------------------------- */
define_function cam_select(integer tp_index, integer cam_index) {
	log_cam("'cam_select() tp_index=', itoa(tp_index), ', cam_index=', itoa(cam_index)")
	if (is_range(tp_index, 1, NUM_TP) && is_range(cam_index, 1, NUM_CAM)) {
		camSelected[tp_index] = cam_index
	}
}
/* -------------------------------------------------------------------------- */
define_constant
integer BTN_CAM_MOVE_UP = 101
integer BTN_CAM_MOVE_DOWN = 102
integer BTN_CAM_MOVE_LEFT = 103
integer BTN_CAM_MOVE_RIGHT = 104
integer BTN_CAM_ZOOM_IN = 105
integer BTN_CAM_ZOOM_OUT = 106
integer BTN_CAM_SET_SPEED = 107
integer BTN_CAM_SET_SPEED_SLOW = 108
integer BTN_CAM_SET_SPEED_FAST = 109
integer BTN_CAM_SELECT[9]  = { 111, 112, 113, 114, 115, 116, 117, 118, 119 }
integer BTN_CAM_PRESET[] = {
	1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
	21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38,39, 40,
	41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60,
	61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80,
	81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99
}
/* -------------------------------------------------------------------------- */
define_function ui_refresh_cam_select(integer tp_index) {
	if (!tp_index) {
		integer i
		for (i = 1; i <= NUM_TP; i++) {
			ui_refresh_cam_select(i)
		}
		return
	}
	else {
		tp_set_btn_in_array(TP_CAM[tp_index], BTN_CAM_SELECT, camSelected[tp_index])
	}
}
define_function ui_refresh_cam_preset_recall(integer tp_index) {
	if (!tp_index) {
		integer i
		for (i = 1; i <= NUM_TP; i++) {
			ui_refresh_cam_preset_recall(i)
		}
		return
	}
	else {
		if (camSelected[tp_index]) {
			tp_set_btn_in_array(TP_CAM[tp_index], BTN_CAM_PRESET, camLastRecallPreset[camSelected[tp_index]])
		}
		else {
			tp_set_btn_in_array(TP_CAM[tp_index], BTN_CAM_PRESET, false)
		}
	}
}
/* -------------------------------------------------------------------------- */
define_function ui_refresh_cam_speed() {
	ch_set_ss(TP_CAM, BTN_CAM_SET_SPEED_SLOW, !(camSpeed))
	ch_set_ss(TP_CAM, BTN_CAM_SET_SPEED_FAST, camSpeed)
	ch_set_ss(TP_CAM, BTN_CAM_SET_SPEED, camSpeed)
}
/* -------------------------------------------------------------------------- */
define_start {
	cam_set_speed(true)
}
/* -------------------------------------------------------------------------- */
define_event
button_event[TP_CAM, BTN_CAM_SELECT] {
	push: {
		cam_select(get_last(TP_CAM), get_last(BTN_CAM_SELECT))
		ui_refresh_cam_select(get_last(TP_CAM))
	}
}
define_event
button_event[TP_CAM, BTN_CAM_MOVE_UP] {
	push: {
		cam_move_up(camSelected[get_last(TP_CAM)])
	}
	release: {
		cam_stop_move(camSelected[get_last(TP_CAM)])
	}
}
define_event
button_event[TP_CAM, BTN_CAM_MOVE_DOWN] {
	push: {
		cam_move_down(camSelected[get_last(TP_CAM)])
	}
	release: {
		cam_stop_move(camSelected[get_last(TP_CAM)])
	}
}
define_event
button_event[TP_CAM, BTN_CAM_MOVE_LEFT] {
	push: {
		cam_move_left(camSelected[get_last(TP_CAM)])
	}
	release: {
		cam_stop_move(camSelected[get_last(TP_CAM)])
	}
}
define_event
button_event[TP_CAM, BTN_CAM_MOVE_RIGHT] {
	push: {
		cam_move_right(camSelected[get_last(TP_CAM)])
	}
	release: {
		cam_stop_move(camSelected[get_last(TP_CAM)])
	}
}
define_event
button_event[TP_CAM, BTN_CAM_ZOOM_IN] {
	push: {
		cam_zoom_in(camSelected[get_last(TP_CAM)])
	}
	release: {
		cam_stop_zoom(camSelected[get_last(TP_CAM)])
	}
}
define_event
button_event[TP_CAM, BTN_CAM_ZOOM_OUT] {
	push: {
		cam_zoom_out(camSelected[get_last(TP_CAM)])
	}
	release: {
		cam_stop_zoom(camSelected[get_last(TP_CAM)])
	}
}
define_event
button_event[TP_CAM, BTN_CAM_SET_SPEED] {
	push: {
		cam_set_speed(!camSpeed)
	}
}
define_event
button_event[TP_CAM, BTN_CAM_SET_SPEED_SLOW] {
	push: {
		cam_set_speed(false)
		ui_refresh_cam_speed()
	}
}
define_event
button_event[TP_CAM, BTN_CAM_SET_SPEED_FAST] {
	push: {
		cam_set_speed(true)
		ui_refresh_cam_speed()
	}
}
define_event
button_event[TP_CAM, BTN_CAM_PRESET] {
	hold[13]: {
		integer preset_index
		integer tp_index
		preset_index = get_last(BTN_CAM_PRESET)
		tp_index = get_last(TP_CAM)
		/* -------------------------------------------------------------------------- */
		if (camSelected[tp_index]) {
			cam_store_preset(camSelected[tp_index], preset_index)
			ui_show_notification (
				/* N번 프리셋이 저장되었습니다. */
				get_last(TP_CAM),
				"
				itounicode(preset_index, 2),
				'BC880020D504B9ACC14BC7740020C800C7A5B418C5C8C2B5B2C8B2E4002E'
				"
			)
			camStoreMode[tp_index] = true
		}
	}
	release: {
		integer preset_index
		integer tp_index
		preset_index = get_last(BTN_CAM_PRESET)
		tp_index = get_last(TP_CAM)
		if (!camStoreMode[tp_index]) {
			if (camSelected[tp_index]) {
				cam_recall_preset(camSelected[tp_index], preset_index)
				camLastRecallPreset[camSelected[tp_index]] = preset_index
				ui_refresh_cam_preset_recall(tp_index)
			}
		}
		camStoreMode[tp_index] = false
		ui_refresh_cam_preset_recall(tp_index)
	}
}
/* -------------------------------------------------------------------------- */
define_event
timeline_event[TLID_UI_UPDATE] {
	ui_refresh_cam_select(0)
	ui_refresh_cam_preset_recall(0)
	ui_refresh_cam_speed()
}
/* -------------------------------------------------------------------------- */
