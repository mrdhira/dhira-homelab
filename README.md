# Homelab with Raspberry Pi 5 (Ubuntu 24.04 + Docker)

This repo organizes each self-hosted app into its own folder under `apps/`.

## Apps
- [Portainer](apps/portainer/) → Docker management UI
- [CasaOS](apps/casaos/) → App-store style homelab manager
- (Add more apps: Nextcloud, Plex, Uptime Kuma, etc.)

## Usage

Clone this repo:
```bash
git clone https://github.com/<your-username>/homelab.git
cd homelab
```

# Glance (Homelab Dashboard)

A lightweight, beautiful startpage for your homelab services.

- URL: http://<pi-ip>:7000
- Config: `glance.yml` in `apps/glance/config/`

## Commands
```bash
make up name=glance
make logs name=glance
make down name=glance
make clean name=glance
```

## Customization

Edit apps/glance/config/glance.yml to add your own sections and links.
Restart after changes:
```
make restart name=glance
```
