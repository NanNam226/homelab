#!/usr/bin/with-contenv bash
# shellcheck shell=bash
# Inject repo-managed Jellyfin custom CSS into the bundled web UI.
# This keeps the color tweak outside the image while reapplying it after container recreates.
set -euo pipefail

WEB_DIR="/usr/share/jellyfin/web"
INDEX_FILE="${WEB_DIR}/index.html"
CSS_FILE="${WEB_DIR}/custom-progress.css"
CSS_LINK='<link rel="stylesheet" href="custom-progress.css">'

if [[ ! -f "${INDEX_FILE}" ]]; then
    echo "[jellyfin-custom-css] ${INDEX_FILE} not found; skipping CSS injection"
    exit 0
fi

if [[ ! -f "${CSS_FILE}" ]]; then
    echo "[jellyfin-custom-css] ${CSS_FILE} not found; skipping CSS injection"
    exit 0
fi

if grep -Fq 'custom-progress.css' "${INDEX_FILE}"; then
    echo "[jellyfin-custom-css] custom CSS already injected"
    exit 0
fi

if ! grep -Fq '</head>' "${INDEX_FILE}"; then
    echo "[jellyfin-custom-css] </head> not found in ${INDEX_FILE}; skipping CSS injection"
    exit 0
fi

sed -i "s#</head>#${CSS_LINK}</head>#" "${INDEX_FILE}"
echo "[jellyfin-custom-css] injected custom-progress.css"
