/* -------------------------------------------------------------------------- */
program_name = 'bluray'
/* -------------------------------------------------------------------------- */
// SECTION LG BLURAY IR
/* -------------------------------------------------------------------------- */
define_device
DV_IR = 5001:11:0
/* -------------------------------------------------------------------------- */
define_constant
integer IRCODE_BLURAY_PLAY = 1
integer IRCODE_BLURAY_STOP = 2
integer IRCODE_BLURAY_PAUSE = 3
integer IRCODE_BLURAY_EJECT = 80
integer IRCODE_BLURAY_RW = 7
integer IRCODE_BLURAY_FF = 6
integer IRCODE_BLURAY_R_SKIP = 5
integer IRCODE_BLURAY_F_SKIP = 4
integer IRCODE_BLURAY_RETURN = 54
integer IRCODE_BLURAY_HOME = 44
integer IRCODE_BLURAY_DISCMENU = 111
integer IRCODE_BLURAY_TITLE_MENU = 51
integer IRCODE_BLURAY_INFO = 94
integer IRCODE_BLURAY_POWER = 9
integer IRCODE_BLURAY_UP = 45
integer IRCODE_BLURAY_LEFT = 47
integer IRCODE_BLURAY_ENTER = 49
integer IRCODE_BLURAY_RIGHT = 48
integer IRCODE_BLURAY_DOWN = 46
/* -------------------------------------------------------------------------- */
define_event
data_event[DV_IR] {
	online: {
		send_command data.device,"'SET MODE IR'"
		send_command data.device,"'CARON'"
	}
}
/* -------------------------------------------------------------------------- */
// SECTION TP PORT 9 LG BLURAY IR
/* -------------------------------------------------------------------------- */
define_device
TP_10001_BLURAY = 10001:9:0
/* -------------------------------------------------------------------------- */
define_constant
dev TP_BLURAY[NUM_TP] = { TP_10001_BLURAY }
/* -------------------------------------------------------------------------- */
define_event
button_event[TP_BLURAY, 0] {
	push: {
		integer button_index
		button_index = button.input.channel
		switch (button_index) {
			case IRCODE_BLURAY_PLAY:
			case IRCODE_BLURAY_STOP:
			case IRCODE_BLURAY_PAUSE:
			case IRCODE_BLURAY_EJECT:
			case IRCODE_BLURAY_RW:
			case IRCODE_BLURAY_FF:
			case IRCODE_BLURAY_R_SKIP:
			case IRCODE_BLURAY_F_SKIP:
			case IRCODE_BLURAY_RETURN:
			case IRCODE_BLURAY_HOME:
			case IRCODE_BLURAY_DISCMENU:
			case IRCODE_BLURAY_TITLE_MENU:
			case IRCODE_BLURAY_INFO:
			case IRCODE_BLURAY_POWER:
			case IRCODE_BLURAY_UP:
			case IRCODE_BLURAY_LEFT:
			case IRCODE_BLURAY_ENTER:
			case IRCODE_BLURAY_RIGHT:
			case IRCODE_BLURAY_DOWN: {
				ch_pulse(DV_IR, button_index, 2)
			}
		}
	}
	hold[2, repeat]: {
		integer button_index
		button_index = button.input.channel
		switch (button_index) {
			case IRCODE_BLURAY_UP:
			case IRCODE_BLURAY_LEFT:
			case IRCODE_BLURAY_ENTER:
			case IRCODE_BLURAY_RIGHT:
			case IRCODE_BLURAY_DOWN: {
				ch_pulse(DV_IR, button_index, 2)
			}
		}
	}
}
/* -------------------------------------------------------------------------- */
