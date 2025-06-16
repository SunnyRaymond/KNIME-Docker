# KNIME Docker Image 🐳

**One Docker image = full KNIME Analytics Platform 5.4 + Eclipse RCP SDK + a lightweight remote desktop (Fluxbox + VNC + noVNC).**  
Build once, run anywhere, develop KNIME plug-ins or regular workflows right from your browser.

---

## 📋 Prerequisites

| Tool / Capability | Minimum version | Notes |
|-------------------|-----------------|-------|
| **Docker Desktop** | 4.30 + (Windows 11/macOS) <br> _or_ Docker Engine 20.10 + (Linux) | Enable WSL 2 / Hyper‑V on Windows; enable “Use the WSL 2 based engine” in Docker Desktop settings. |
| **CPU virtualization** | VT‑x / AMD‑V enabled | Required for WSL 2 / Hyper‑V (Windows) and for most desktop hypervisors. |
| **RAM** | ≥ 4 GB free | KNIME alone likes memory; give the container 4–6 GB if you can. |
| **Browser** | Any modern HTML5 browser (Chrome, Edge, Firefox, Safari) | Needed only for the **noVNC** web client on port 6080. |
| *(optional)* VNC viewer | TigerVNC, RealVNC, TightVNC … | Connect to `localhost:5900` for native performance and clipboard sync. |

> 💡 **Windows users:** PowerShell treats the back‑tick (`` ` ``) as a line‑continuation _only_ when it is the very last character on a line—no trailing spaces!  Copy‑paste the examples exactly.


---
## ⚡ Quick start (Windows 11 shown; macOS/Linux is the same minus PowerShell quirks)
### 1. Clone this repo
```powershell
git clone https://github.com/SunnyRaymond/KNIME-Docker.git
cd KNIME-Docker
```
### 2. Build the image (takes ~5–7 min the first time)
```powershell
docker build -t knime-sdk .
```

### 3. Run the container
```powershell
docker run -d --name knime `
  -p 6080:6080 -p 5900:5900 `
  -v "$env:USERPROFILE\knime-ws:/workspace" `
  knime-sdk
````

### 4. Open the desktop

| Method          | URL / host                                                       | Notes                                             |
| --------------- | ---------------------------------------------------------------- | ------------------------------------------------- |
| Browser (noVNC) | [http://localhost:6080/vnc.html](http://localhost:6080/vnc.html) | Click **Connect** → Fluxbox panel + KNIME splash. |
| VNC viewer      | `localhost:5900`                                                 | No password set by default.                       |

### Optional: Stop & remove the container:

```powershell
docker rm -f knime
```

---

## 🗂 Directory layout

```
knime-sdk-setup/
├─ Dockerfile            # everything is here
├─ start-knime-vnc.sh    # tiny entrypoint: Xvfb → Fluxbox → x11vnc + websockify → KNIME
└─ README.md             # you’re reading it 🙂
```

Mounted **workspace** lives on the host at:

```
%USERPROFILE%\knime-ws          # Win
~/knime-ws                      # macOS/Linux
```

---

## 🪪 License

This repository is MIT-licensed. The Docker image merely **repackages** Eclipse
(R) and KNIME (R), whose own licenses (EPL 2.0, BSD-like) continue to apply.
No affiliation with Eclipse Foundation or KNIME AG.
```

