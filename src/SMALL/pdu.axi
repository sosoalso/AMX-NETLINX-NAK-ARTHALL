/* -------------------------------------------------------------------------- */
program_name = 'pdu'
/* -------------------------------------------------------------------------- */
// SECTION PDU SP-8S PQS-108
/*
 * INFO PINOUT
 * 5: W/B : D+
 * 6: G   : D-
*/
/* -------------------------------------------------------------------------- */
define_device
DV_PDU = 5001:1:0
/* -------------------------------------------------------------------------- */
define_event
data_event[DV_PDU] {
	online: {
		send_command data.device, "'SET BAUD 9600 N,8,1 485 ENABLE'"
	}
}
/* -------------------------------------------------------------------------- */
define_function sp8s_set_power(dev dv, integer unit, integer state) {
	integer s, u, m
	m = $04
	s = state & true
	u = unit & $FF
	send_command dv, "$54, m, s, $FF, u, $FF"
}
/* -------------------------------------------------------------------------- */
define_function psq108_set_power(dev dv, integer unit, integer state) {
	integer s, u, m
	m = $02
	s = state & true
	u = unit & $FF
	send_command dv, "$54, m, s, $FF, u, $FF"
}
/* -------------------------------------------------------------------------- */
#WARN 'check pdu model'
/* -------------------------------------------------------------------------- */
define_function pdu_set_power(integer state) {
	sp8s_set_power(DV_PDU, 0, state)
}
/* -------------------------------------------------------------------------- */
// SECTION TP PORT 8 PDU
/* -------------------------------------------------------------------------- */
define_device
TP_10001_PDU = 10001:8:0
/* -------------------------------------------------------------------------- */
define_constant
dev TP_PDU[NUM_TP] = { TP_10001_PDU }
/* -------------------------------------------------------------------------- */
define_variable
persistent integer pduPower
/* -------------------------------------------------------------------------- */
define_event
button_event[TP_PDU, 11] {
	push: {
		pdu_set_power(true)
		pduPower = true
	}
}
define_event
button_event[TP_PDU, 12] {
	push: {
		pdu_set_power(false)
		pduPower = false
	}
}
/* -------------------------------------------------------------------------- */
define_function ui_refresh_pdu() {
	tp_set_btn_ss(TP_PDU, 11, pduPower)
	tp_set_btn_ss(TP_PDU, 12, !pduPower)
}
/* -------------------------------------------------------------------------- */
