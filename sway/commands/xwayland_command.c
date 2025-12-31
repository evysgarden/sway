#include "sway/config.h"
#include "log.h"
#include "sway/commands.h"
#include "sway/server.h"
#include "util.h"

struct cmd_results *cmd_xwayland_command(int argc, char **argv) {
	struct cmd_results *error = NULL;
	if ((error = checkarg(argc, "xwayland_command", EXPECTED_EQUAL_TO, 1))) {
		return error;
	}

#ifdef WLR_HAS_XWAYLAND
	char* xwayland_command = join_args(argv, argc);

	if (config->reloading && strcmp(xwayland_command, config->xwayland_command)) {
		return cmd_results_new(CMD_FAILURE,
				"xwayland_command can only be set at launch");
	}

	free(config->xwayland_command);
	config->xwayland_command = xwayland_command;
#else
	sway_log(SWAY_INFO, "Ignoring `xwayland_command` command, "
		"sway hasn't been built with Xwayland support");
#endif

	return cmd_results_new(CMD_SUCCESS, NULL);
}
