# ──────────────────────────────────────────────────────────────────────
# KNIME Analytics Platform SDK + headless desktop (VNC / noVNC)
# Ubuntu 24.04  •  Eclipse 2024-03 RCP  •  KNIME 5.4.0  •  Java 17
# ──────────────────────────────────────────────────────────────────────

FROM ubuntu:24.04
LABEL maintainer="yichen.guo@stengg.com"

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

# 1. Core packages + desktop runtime + SWT/GTK prerequisites
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        wget tar curl git git-lfs ca-certificates locales tzdata \
        openjdk-17-jdk \
        xvfb fluxbox x11vnc novnc websockify \
        libgtk-3-0 libgdk-pixbuf2.0-0 libglib2.0-0 libatk1.0-0 \
        libcairo2 libpango-1.0-0 libpangocairo-1.0-0 \
        libxext6 libxi6 libxrender1 libxtst6 libxinerama1 libxss1 \
        libcanberra-gtk3-0 libwebkit2gtk-4.1-0 \
        libgl1 \
        x11-utils lsof && \
    apt-get clean && rm -rf /var/lib/apt/lists/*



# 2. Eclipse SDK (RCP/RAP) – extracted directly to /opt/eclipse
RUN mkdir -p /opt/eclipse && \
    wget -qO- \
      https://download.eclipse.org/technology/epp/downloads/release/2024-03/R/eclipse-rcp-2024-03-R-linux-gtk-x86_64.tar.gz \
    | tar --strip-components=1 -xz -C /opt/eclipse

# 3. KNIME Analytics Platform (binary) – extracted to /opt/knime
RUN mkdir -p /opt/knime && \
    wget -qO- \
      https://download.knime.org/analytics-platform/linux/knime_5.4.0.linux.gtk.x86_64.tar.gz \
    | tar --strip-components=1 -xz -C /opt/knime

# 4. Create an empty workspace folder (mapped to host at runtime)
RUN mkdir -p /workspace
VOLUME /workspace

# 5. Copy startup script
# copy the script first
COPY start-eclipse-vnc.sh /usr/local/bin/start-eclipse-vnc.sh

# make executable *and* convert CRLF → LF
RUN chmod +x /usr/local/bin/start-eclipse-vnc.sh \
 && sed -i 's/\r$//' /usr/local/bin/start-eclipse-vnc.sh

EXPOSE 5901 6080
CMD ["/usr/local/bin/start-eclipse-vnc.sh"]
