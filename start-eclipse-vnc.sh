#!/usr/bin/env bash
set -euo pipefail

# ----------------------------------------------------------------------
# Config (override with env vars if you want)
# ----------------------------------------------------------------------
DISPLAY_NUM=${DISPLAY:-:1}
RESOLUTION=${VNC_RESOLUTION:-1280x800x24}
VNC_PW_OPT=""
if [[ -n "${VNC_PASSWORD:-}" ]]; then
  VNC_PW_OPT="-passwd $VNC_PASSWORD"
fi

# ----------------------------------------------------------------------
# 1) headless X server
# ----------------------------------------------------------------------
echo "[start] Xvfb $DISPLAY_NUM ($RESOLUTION)"
Xvfb "$DISPLAY_NUM" -screen 0 "$RESOLUTION" &
XVFB_PID=$!
sleep 2   # give it a moment

# ----------------------------------------------------------------------
# 2) lightweight window manager
# ----------------------------------------------------------------------
echo "[start] fluxbox"
fluxbox -display "$DISPLAY_NUM" &
FLUX_PID=$!

# ----------------------------------------------------------------------
# 3) KNIME GUI (starts on the virtual display)
# ----------------------------------------------------------------------
echo "[start] KNIME"
( DISPLAY=$DISPLAY_NUM /opt/knime/knime --launcher.suppressErrors ) &
KNIME_PID=$!

# ----------------------------------------------------------------------
# 4) raw VNC server
# ----------------------------------------------------------------------
echo "[start] x11vnc on :5900"
x11vnc -display "$DISPLAY_NUM" -rfbport 5900 $VNC_PW_OPT -forever -shared -quiet &
VNC_PID=$!

# ----------------------------------------------------------------------
# 5) noVNC bridge → WebSockets on :6080
# ----------------------------------------------------------------------
echo "[start] websockify on :6080"
websockify --web /usr/share/novnc --heartbeat 30 6080 localhost:5900 &
WS_PID=$!

echo "------------------------------------------------------------------------"
echo "  • Browser      : http://localhost:6080/vnc.html"
echo "  • Native  VNC  : localhost:5900  (password = \"${VNC_PASSWORD:-<none>}\")"
echo "------------------------------------------------------------------------"

# Wait for any child to exit (container stops if one of them dies)
wait -n "$XVFB_PID" "$FLUX_PID" "$KNIME_PID" "$VNC_PID" "$WS_PID"
