#!/bin/bash

if [ -z "$XILINX_INSTALL_PATH" ]; then
        XILINX_INSTALL_PATH="$XDG_DATA_HOME/xilinx"
fi

find "$XILINX_INSTALL_PATH" -mindepth 2 -maxdepth 2 -name "*settings64*.sh" -exec sed -i '3 a\XILINX_BASE_PATH=$(readlink -f "$(dirname "$(readlink -f "$BASH_SOURCE")")/..")' {} \;
find "$XILINX_INSTALL_PATH" -mindepth 3 -maxdepth 3 -name "*settings64*.sh" -exec sed -i '3 a\XILINX_BASE_PATH=$(readlink -f "$(dirname "$(readlink -f "$BASH_SOURCE")")/../..")' {} \;
find "$XILINX_INSTALL_PATH" -maxdepth 3 -name "*settings64*.sh" -exec sed -i -E "s@([ =]).+/(DocNav|Vivado|Vitis)@\1\$XILINX_BASE_PATH/\2@g" {} \;
