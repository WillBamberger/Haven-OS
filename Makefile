ISO_NAME = haven-os
BUILD-DIR = build/iso
OVERLAY_DIR = overlay
ISO_OUTPUT = $(BUILD_DIR)/$(ISO_NAME).iso

.PHONY: all iso prepare-overlay check clean

all: iso

iso: check
 sudo mkarch iso -v -o $(BUILD_DIR) .

prepare-overlay:
 @echo "Preparing overlay root filesystem..."

 # Create necessary dirs
 mkdir -p $(USR_LIB_HAVEN_DIR)
 mkdir -p $(SYSTEMD_DIR)
 mkdir -p $(WANTS_DIR)

 # Copy service files
 cp $(NAT_SERVICE_SRC) $(SYSTEMD_DIR)/
 cp $(ROUTER_SERVICE_SRC) $(SYSTEMD_DIR)/

 # Symlink for auto-start
 ln -sf ../router.service $(WANTS_DIR)/router
 # 
check:
 @if [ ! -f $(OVERLAY_DIR)/usr/lib/haven/openwrt.img ]; then
  echo "ERROR: openwrt.img  not found in $(OVERLAY_DIR)/usr/lib/haven/";
  echo "Please make sure the OpenWrt image is included in the repo.";
  exit 1;
 fi

clean:
 sudo rm -rf $(BUILD_DIR)
