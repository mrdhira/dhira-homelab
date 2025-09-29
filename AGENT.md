# Homelab Agent Notes – Raspberry Pi 5 (Ubuntu 24.04 + Docker)

This file documents the design choices, notes, and troubleshooting tips for my Raspberry Pi 5 homelab.  
It is meant to onboard anyone (or remind myself) about the current setup and lessons learned.

---

## 🖥️ Base Setup
- **Hardware**: Raspberry Pi 5 (8GB RAM)
- **OS**: Ubuntu 24.04.3 LTS
- **Runtime**: Docker + Docker Compose
- **Firewall**: UFW
- **Web Proxy**: Nginx (default config now, will evolve into reverse proxy)

---

## 🗂️ Repo Structure (planned)
```
homelab/
├── apps/
│   ├── portainer/
│   │   └── docker-compose.yml
│   ├── casaos/
│   │   └── docker-compose.yml
│   └── glance/
│       └── docker-compose.yml
├── config/
│   └── glance/
│       └── glance.yml
├── docker/
├── Makefile
├── README.md
└── AGENT.md
```

- Each app has its own **docker-compose.yml** inside `apps/<appname>/`.
- **Configs live under `/config/`** for easier backups and versioning.
- The **Makefile** manages single apps or all apps at once.

---

## 📦 Container Management: Portainer vs CasaOS

### 🔹 Portainer
- Technical Docker/Kubernetes manager.
- Pros: fine-grained control, supports Compose & Swarm, multi-host.
- Cons: requires Docker knowledge; no "app store" feel.

### 🔹 CasaOS
- App-store style homelab dashboard.
- Pros: user-friendly UI, one-click install for common apps.
- Cons: less flexible, limited user management, single host.

👉 Both run as **containers**, managing the same Docker engine.  
👉 You can install both side-by-side and decide which you prefer.

---

## ⚙️ CasaOS vs ZimaOS

- **CasaOS** = software layer on top of Linux, app/dashboard focus.
- **ZimaOS** = full NAS-centric OS, more storage features, built for bare metal (mostly x86).
- For Raspberry Pi (ARM, Ubuntu base), **CasaOS in Docker** is the option.

**Working CasaOS image**: `dockurr/casa`  
Compose snippet used in this repo:
```yaml
services:
  casaos:
    image: dockurr/casa:latest
    container_name: casaos
    restart: unless-stopped
    ports:
      - "8080:8080"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - casaos_data:/DATA

volumes:
  casaos_data:
```

---

## 🖥️ Glance (Dashboard)

- **Purpose**: Startpage / bookmark dashboard for homelab apps.  
- **Config**: `config/glance/glance.yml`  
- **URL**: `http://<pi-ip>:7000`  

Correct example config:
```yaml
theme:
  name: dark

title: Dhira Homelab
subtitle: Raspberry Pi 5 · Ubuntu 24.04 · Docker

pages:
  - name: Home
    columns:
      - size: full
        widgets:
          - type: bookmarks
            groups:
              - title: Services
                links:
                  - title: Portainer
                    url: http://pi.local:9000
                    icon: docker
                  - title: CasaOS
                    url: http://pi.local:8080
                    icon: home
```

👉 Glance requires at least one `pages:` block.  
👉 Glance does **not** expose system metrics.  
👉 Use `glances` (installed via `apt install glances`) if you want a system monitor.

---

## 🔑 Makefile Usage

### Single app
```bash
make up name=portainer
make logs name=casaos
make down name=portainer
make clean name=casaos
```

### All apps
```bash
make up-all
make ps-all
make restart-all
make down-all
```

---

## 🔒 UFW + Docker Notes

- **Problem**: Docker bypasses UFW by inserting iptables NAT rules directly.
- That’s why ports like `:9000` (Portainer) are accessible even if UFW blocks them.
- **Fix strategies**:
  - Bind services to **127.0.0.1** and expose them only via Nginx reverse proxy.
  - Or disable Docker’s iptables management (`"iptables": false` in `/etc/docker/daemon.json`).
- Recommended: use **reverse proxy (Nginx + TLS)** and expose only `80` + `443`.

---

## 📝 Future Plans

- Add more apps (Nextcloud, Plex, Uptime Kuma, Gotify, etc.) as separate `apps/` folders.
- Migrate persistent Docker volumes into `/srv/<app>` for backup/restore consistency.
- Integrate Cloudflared tunnel for secure remote access.
- Setup Nginx reverse proxy configs for Portainer + CasaOS (bound to localhost).
