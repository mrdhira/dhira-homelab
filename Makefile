APPS_DIR=apps

.PHONY: up down restart logs ps clean up-all down-all restart-all ps-all

# ----------------------------
# Single app commands
# Usage: make up name=portainer
# ----------------------------

up:
	cd $(APPS_DIR)/$(name) && docker compose up -d

down:
	cd $(APPS_DIR)/$(name) && docker compose down

restart:
	cd $(APPS_DIR)/$(name) && docker compose down && docker compose up -d

logs:
	cd $(APPS_DIR)/$(name) && docker compose logs -f

ps:
	cd $(APPS_DIR)/$(name) && docker compose ps

clean:
	cd $(APPS_DIR)/$(name) && docker compose down -v --remove-orphans

# ----------------------------
# All apps at once
# ----------------------------

up-all:
	@for d in $(APPS_DIR)/*; do \
		echo ">>> Starting $$d..."; \
		(cd $$d && docker compose up -d); \
	done

down-all:
	@for d in $(APPS_DIR)/*; do \
		echo ">>> Stopping $$d..."; \
		(cd $$d && docker compose down); \
	done

restart-all:
	@for d in $(APPS_DIR)/*; do \
		echo ">>> Restarting $$d..."; \
		(cd $$d && docker compose down && docker compose up -d); \
	done

ps-all:
	@for d in $(APPS_DIR)/*; do \
		echo ">>> Status for $$d"; \
		(cd $$d && docker compose ps); \
	done
