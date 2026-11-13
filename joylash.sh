#!/bin/bash
# Ustoz YouTube havolasi: «YouTube ilovasida ochish» sahifasini GitHub Pages'ga joylaydi (osmanceowork-cmd/yt, ochiq repo).
set -e
cd "$(dirname "$0")"
R=osmanceowork-cmd/yt
[ -d .git ] || { git init -q -b main; git add -A; git -c user.name="OSMAN" -c user.email="osmanceowork-cmd@users.noreply.github.com" commit -qm "Ustoz YouTube: ilovada ochish sahifasi"; }
gh repo view $R >/dev/null 2>&1 || gh repo create $R --public --description "Instagram Direct -> YouTube ilovasi (Ustoz oxirgi videosi)"
git remote get-url origin >/dev/null 2>&1 || git remote add origin https://github.com/$R.git
git push -q -u origin main
gh api -X POST repos/$R/pages -f build_type=workflow >/dev/null 2>&1 || gh api -X PUT repos/$R/pages -f build_type=workflow >/dev/null
sleep 8
gh workflow run oxirgi-video.yml -R $R
sleep 8
RID=$(gh run list -R $R --workflow oxirgi-video.yml --event workflow_dispatch --limit 1 --json databaseId -q '.[0].databaseId')
gh run watch -R $R "$RID" --exit-status >/dev/null && echo "Tayyor: https://osmanceowork-cmd.github.io/yt/"
