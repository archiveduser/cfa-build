#!/bin/bash
sed -i 's/const defaultPersistOverride = `{"dns":{"enable": false}, "redir-port": 0, "tproxy-port": 0}`/const defaultPersistOverride = `{}`/g' ./cfa/core/src/main/golang/native/config/override.go
sed -i 's/create("foss")/create("kamino")/g' ./cfa/build.gradle.kts
sed -i 's/.foss/.kamino/g' ./cfa/build.gradle.kts
sed -i 's/create("foss")/create("kamino")/g' ./cfa/core/build.gradle.kts
