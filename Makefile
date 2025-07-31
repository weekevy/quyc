# main paths
#
#
#
INSTALL_DIR=/usr/local/ultraquery
BIN_DIR=/usr/local/bin
#
#
install:
	@echo "Installing ultraquery..."
	sudo mkdir -p $(INSTALL_DIR)
	sudo cp -r ultraquery.sh modules wordlists $(INSTALL_DIR)
	sudo ln -sf $(INSTALL_DIR)/ultraquery.sh $(BIN_DIR)/ultraquery
	sudo chmod +x $(INSTALL_DIR)/ultraquery.sh $(INSTALL_DIR)/modules/*.sh
	@echo "Installed. You can now run it with: ultraquery <module>"
uninstall:
	@echo " Uninstalling ultraquery..."
	sudo rm -rf $(INSTALL_DIR)
	sudo rm -f $(BIN_DIR)/ultraquery
	@echo "Uninstalled successfully."

update:
	@echo "Updating ultraquery files..."
	sudo cp -r ultraquery.sh modules wordlists $(INSTALL_DIR)
	@echo "Update complete."
help:
	@echo ""
	@echo "  make uninstall     Uninstall the tool"
	@echo "  make update        Update the installed version"
	@echo "  make help          Show this message"
	@echo ""
