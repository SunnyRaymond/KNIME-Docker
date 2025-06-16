# KNIME-SDK-in-a-Box 🐳

**One Docker image = full KNIME Analytics Platform 5.4 + Eclipse RCP SDK + a lightweight remote desktop (Fluxbox + VNC + noVNC).**  
Build once, run anywhere, develop KNIME plug-ins or regular workflows right from your browser.

---
## ⚡ Quick start (Windows 11 shown; macOS/Linux is the same minus PowerShell quirks)
### 1. Clone this repo
```powershell
git clone https://github.com/<you>/knime-sdk-setup.git
cd knime-sdk-setup
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

