/* -------------------------------------------------------------------------- */
program_name = 'cdp'
/* -------------------------------------------------------------------------- */
// SECTION DENON CD PLAYER
/* -------------------------------------------------------------------------- */
define_device
DV_CDP_01 = 5001:3:1
/* -------------------------------------------------------------------------- */
define_constant
char CDP_CMD_STANDBY[] = '02312'
char CDP_CMD_POWERON[] = '023PW'
char CDP_CMD_STOP[] = '02354'
char CDP_CMD_PLAY[] = '02353'
char CDP_CMD_PAUSEPLAY[] = '02348'
char CDP_CMD_SKIPBACK[] = '023SB'
char CDP_CMD_CUE[] = '023CU'
char CDP_CMD_FASTFORWARD[] = '02332'
char CDP_CMD_REWIND[] = '02333'
char CDP_CMD_TRACKJUMPNEXT[] = '02350'
char CDP_CMD_TRACKJUMPPREV[] = '02352'
char CDP_CMD_RECORD[] = '02355'
char CDP_CMD_PAUSERECORD[] = '023Rp'
/* -------------------------------------------------------------------------- */
define_function cdp_send(dev dv, char cmd[]) {
	send_string dv, "'@', cmd, $0D"
}
/* -------------------------------------------------------------------------- */
// SECTION TP PORT 7 DENON CD PLAYER
/* -------------------------------------------------------------------------- */
define_device
TP_10001_CDP = 10001:7:0
/* -------------------------------------------------------------------------- */
define_constant
dev TP_CDP[NUM_TP] = { TP_10001_CDP }
/* -------------------------------------------------------------------------- */
define_event
button_event[TP_CDP, 0] {
	push: {
		integer index_button
		index_button = button.input.channel
		switch (index_button) {
			case 101: {
				cdp_send(DV_CDP_01, CDP_CMD_STANDBY)
			}
			case 102: {
				cdp_send(DV_CDP_01, CDP_CMD_POWERON)
			}
			case 103: {
				cdp_send(DV_CDP_01, CDP_CMD_STOP)
				tp_on_btn_ss(TP_CDP, 103)
				tp_off_btn_ss(TP_CDP, 104)
			}
			case 104: {
				cdp_send(DV_CDP_01, CDP_CMD_PLAY)
				tp_on_btn_ss(TP_CDP, 104)
				tp_off_btn_ss(TP_CDP, 103)
			}
			case 105: {
				cdp_send(DV_CDP_01, CDP_CMD_PAUSEPLAY)
			}
			case 106: {
				cdp_send(DV_CDP_01, CDP_CMD_SKIPBACK)
			}
			case 107: {
				cdp_send(DV_CDP_01, CDP_CMD_CUE)
			}
			case 108: {
				cdp_send(DV_CDP_01, CDP_CMD_FASTFORWARD)
			}
			case 109: {
				cdp_send(DV_CDP_01, CDP_CMD_REWIND)
			}
			case 110: {
				cdp_send(DV_CDP_01, CDP_CMD_TRACKJUMPNEXT)
			}
			case 111: {
				cdp_send(DV_CDP_01, CDP_CMD_TRACKJUMPPREV)
			}
			case 112: {
				cdp_send(DV_CDP_01, CDP_CMD_RECORD)
			}
			case 113: {
				cdp_send(DV_CDP_01, CDP_CMD_PAUSERECORD)
			}
		}
	}
}
/* -------------------------------------------------------------------------- */
