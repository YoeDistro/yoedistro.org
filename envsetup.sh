#!/bin/bash

# Build and deploy script for yoedistro.org
# Usage: source envsetup.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEPLOY_TARGET="yoedistro.org:/srv/http/yoe/website/"

yoe_deploy() {
	echo "Building site with Zola..."
	cd "$SCRIPT_DIR" || return 1
	zola build || return 1
	echo "Deploying to $DEPLOY_TARGET..."
	rsync -avz --delete public/ "$DEPLOY_TARGET"
}

yoe_serve() {
	echo "Starting Zola development server..."
	cd "$SCRIPT_DIR" || return 1
	zola serve
}

echo "Yoe Distro website build environment loaded."
echo "Available commands:"
echo "  yoe_deploy - Build and deploy to $DEPLOY_TARGET"
echo "  yoe_serve  - Start local development server"
