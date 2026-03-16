#!/bin/bash
# Exclude high-churn DevOps directories from Spotlight
sudo mdutil -i off ~/Library/Caches
sudo mdutil -i off ~/.docker # If you're using Docker/OrbStack
sudo mdutil -i off ~/.terraform.d
