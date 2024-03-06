#!/bin/bash

# Make sure out directory exists
mkdir -p out

# Copy mod files to workshop directory
cp -r src out/coavinsfirearms

# Generate models lua from yaml source
lua build/write_models.lua def/CoavinsModels.yml out/coavinsfirearms/Contents/mods/coavinsfirearms/media/lua/client/coavinsfirearms/CoavinsModels.lua
