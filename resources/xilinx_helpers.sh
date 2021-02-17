#/bin/sh

if [ -z "$XILINX_INSTALL_PATH" ]; then
	export XILINX_INSTALL_PATH="/home/$USER/.Xilinx/install"
fi

export LD_LIBRARY_PATH=/app/lib
export LC_NUMERIC=en_US.UTF-8	# Vivado may throw errors on locales which uses comma as decimal separator

function xilinx_install() {
	if [ -f "$XILINX_INSTALL_PATH/.xinstall/xic/xsetup" ]; then
		installer_path="$XILINX_INSTALL_PATH/.xinstall/xic/xsetup"
	else
		zenity --width=600 --info --title "Missing xsetup" --text "xsetup is not installed. Please download the Xilinx Unified installer from\n<b>https://xilinx.com/downloads</b>\nand select it in the next window."

		# Get the installer path
		installer_path=$(zenity --file-selection --title "Select the Xilinx installer (Xilinx_Unified_*_Lin64.bin)")

		zenity --width=600 --warning --text "The Xilinx installer will now start. Make sure to select $XILINX_INSTALL_PATH as installation path."
		mkdir -p "$XILINX_INSTALL_PATH"
	fi

	# Run the installer
	sh "$installer_path"

	zenity --width=600 --info --text "Installation is complete.\nTo allow access to the hardware devices (necessary to program them within Vivado and Vitis), run <b>sudo $XILINX_INSTALL_PATH/Vivado/2020.2/data/xicom/cable_drivers/lin64/install_script/install_drivers/install_drivers &amp;&amp; sudo udevadm control --reload</b>, then reconnect all the devices (if any)"
}

function xilinx_install_if_needed() {
	if [ ! -f "$XILINX_INSTALL_PATH/$1" ]; then
		zenity --width=600 --question --title "Missing software" --text "$1 is not installed in $XILINX_INSTALL_PATH. Do you want to install it now?" && xilinx_install
	fi
}

function xilinx_install_if_needed_then_run() {
	command="$1"
	shift

	xilinx_install_if_needed "$command"
	. "$XILINX_INSTALL_PATH/Vivado/2020.2/settings64.sh"
	"$XILINX_INSTALL_PATH/$command" "$@"
}
