# KNIME-SDK-in-a-Box 🐳

**One Docker image = full KNIME Analytics Platform 5.4 + Eclipse RCP SDK + a lightweight remote desktop (Fluxbox + VNC + noVNC).**  
Build once, run anywhere, develop KNIME plug-ins or regular workflows right from your browser.

---

## ✨ Why you might want this

| Pain 🤕 | This image’s gain 🚀 |
|---------|----------------------|
| *“Setting up Eclipse, KNIME target platform, JDK, GTK libs … on every new machine is a drag.”* | All baked into the image, reproducible across Windows / macOS / Linux. |
| *“I need a GUI, but my dev box is headless / on the cloud.”* | Embedded Xvfb + x11vnc + **noVNC** = KNIME desktop from a browser tab (or any VNC viewer). |
| *“I don’t want to lose my KNIME workspace every time I rebuild.”* | Mount a host folder → persistent `~/workspace` inside the container. |

---

## 🧰  What’s inside

| Layer | Components |
|-------|------------|
| **Base OS** | Ubuntu 24.04 “Noble” (minimal) |
| **Java** | OpenJDK 17 (headful) |
| **IDE stack** | Eclipse 2024-03 RCP SDK + KNIME 5.4.0 Platform |
| **GUI runtime** | Xvfb, Fluxbox WM, x11vnc, noVNC + websockify |
| **Misc. libs** | GTK 3, Cairo, Pango, Mesa GL, WebKitGTK … just enough for SWT/JavaFX |

---

## ⚡ Quick start (Windows 11 shown; macOS/Linux is the same minus PowerShell quirks)

```powershell
# 1. Clone this repo
git clone https://github.com/<you>/knime-sdk-setup.git
cd knime-sdk-setup

# 2. Build the image (takes ~5–7 min the first time)
docker build -t knime-sdk .

# 3. Run it (back-tick MUST be the last char on a line in PowerShell)
docker run -d --name knime `
  -p 6080:6080 `            # noVNC in browser
  -p 5900:5900 `            # raw VNC (optional)
  -v "$env:USERPROFILE\knime-ws:/workspace" ` # persistent workspace
  knime-sdk
````

### Open the desktop

| Method          | URL / host                                                       | Notes                                             |
| --------------- | ---------------------------------------------------------------- | ------------------------------------------------- |
| Browser (noVNC) | [http://localhost:6080/vnc.html](http://localhost:6080/vnc.html) | Click **Connect** → Fluxbox panel + KNIME splash. |
| VNC viewer      | `localhost:5900`                                                 | No password set by default.                       |

Stop & remove the container:

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

## 🔧 Customising

| What                            | How                                                                                                      |
| ------------------------------- | -------------------------------------------------------------------------------------------------------- |
| Change KNIME / Eclipse versions | Edit the URLs in the **Dockerfile** (section “Eclipse SDK” & “KNIME”).                                   |
| Add extra Ubuntu packages       | Insert them in the `apt-get install` list.                                                               |
| Protect VNC with a password     | Set env var `VNC_PASSWORD=secret` at `docker run`, or change the `x11vnc` flags in `start-knime-vnc.sh`. |
| Bind additional ports           | E.g. expose port 8888 for Jupyter or 8080 for web apps: `-p 8888:8888`.                                  |

---

## 🩹 Troubleshooting

| Symptom                                                        | Fix                                                                                                                                                                |
| -------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **`This page isn’t working / ERR_EMPTY_RESPONSE` on 6080**     | Make sure `websockify --web=/usr/share/novnc 6080 localhost:5900` is running. In this image it’s started by `start-knime-vnc.sh`; check logs: `docker logs knime`. |
| PowerShell yells *“`docker run` requires at least 1 argument”* | You hit **Enter** too early or have trailing spaces after back-ticks. Paste the full multi-line command exactly, or use the one-liner.                             |
| VNC connects but KNIME window never shows                      | Wait 5-10 s (first launch builds OSGi cache). Check container CPU usage; look for errors in `docker logs`.                                                         |
| Port already in use                                            | Choose different host ports, e.g. `-p 6081:6080 -p 5901:5900`.                                                                                                     |

---

## 🪪 License

This repository is MIT-licensed. The Docker image merely **repackages** Eclipse
(R) and KNIME (R), whose own licenses (EPL 2.0, BSD-like) continue to apply.
No affiliation with Eclipse Foundation or KNIME AG.

---

## 🤝 Contributing

PRs & issues welcome!  Typical help wanted:

* slim the image further (multi-stage build, strip docs)
* optional TigerVNC instead of x11vnc
* pre-install popular KNIME extensions

---

**Happy data science & plug-in hacking!** 🚀

```

