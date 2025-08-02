
# Makefile for quevy

INSTALL_DIR = /usr/local/quevy
BIN_DIR = /usr/local/bin
SCRIPT_NAME = quevy.sh
LINK_NAME = quevy

install:
	@echo "[+] Installing $(LINK_NAME)..."
	sudo mkdir -p $(INSTALL_DIR)
	sudo cp -r $(SCRIPT_NAME) modules $(INSTALL_DIR)
	sudo chmod +x $(INSTALL_DIR)/$(SCRIPT_NAME)
	sudo ln -sf $(INSTALL_DIR)/$(SCRIPT_NAME) $(BIN_DIR)/$(LINK_NAME)
	@echo "[✔] Installed. You can now run '$(LINK_NAME)' from anywhere."

uninstall:
	@echo "[-] Uninstalling $(LINK_NAME)..."
	sudo rm -f $(BIN_DIR)/$(LINK_NAME)
	sudo rm -rf $(INSTALL_DIR)
	@echo "[✔] Uninstalled '$(LINK_NAME)'"

