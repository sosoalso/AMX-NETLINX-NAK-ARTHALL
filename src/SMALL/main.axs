/* -------------------------------------------------------------------------- */
program_name = 'main'
/* -------------------------------------------------------------------------- */
define_constant integer NUM_TP = 1
#include 'lib_simple_ui'
/* -------------------------------------------------------------------------- */
#include 'cam' // INFO TP PORT 2 PANASONIC CAMERA
#include 'vsw' // INFO TP PORT 3 ATEM VIDEO SWITCHER
#include 'vidrec' // INFO TP PORT 4 BMD HYPERDECK STUDIO
#include 'vidprj' // INFO TP PORT 5 PJLINK
#include 'vidmtx' // INFO TP PORT 6 RTCOM VIDEO MATRIX
#include 'cdp' // INFO TP PORT 7 RTCOM VIDEO MATRIX
#include 'pdu' // INFO TP PORT 8 RTCOM VIDEO MATRIX
#include 'bluray' // INFO TP PORT 9 RTCOM VIDEO MATRIX
#include 'relay' // INFO TP PORT 610 RTCOM VIDEO MATRIX
/* -------------------------------------------------------------------------- */
define_start {
	set_log_level(AMX_INFO)
}
/* -------------------------------------------------------------------------- */
define_event
data_event[DV_TP1] {
	online: {
		if (pduPower) {
			tp_set_page(data.device, '03')
		}
		else {
			tp_set_page(data.device, '01')
		}
	}
}
/* -------------------------------------------------------------------------- */
define_event
button_event[DV_TP1, 201] {
	push: {
		tp_set_page_ss(DV_TP1, '02')
		pdu_set_power(true)
		wait 150 {
			tp_set_page_ss(DV_TP1, '03')
		}
	}
}
/* -------------------------------------------------------------------------- */
/* 시스템 종료 */
define_event button_event[DV_TP1, 202] {
	push: {
		tp_set_page_ss(DV_TP1, '02')
		pdu_set_power(false)
		/* -------------------------------------------------------------------------- */
		vidprj_power_off()
		/* -------------------------------------------------------------------------- */
		wait 150 {
			tp_set_page_ss(DV_TP1, '01')
		}
	}
}
/* -------------------------------------------------------------------------- */
