#!/usr/bin/env bash
RootPath=$(cd $(dirname $0)/..; pwd)

Version=`git describe --abbrev=0 --tags 2>/dev/null`
BranchName=`git rev-parse --abbrev-ref HEAD 2>/dev/null`
CommitID=`git rev-parse HEAD 2>/dev/null`
BuildTime=`date +%Y-%m-%d\ %H:%M`

SrcPath=${RootPath}/sdklib
case `uname` in
    Darwin)
        TargetFile=${1:-$RootPath/sdklib/libsdk.dylib}
        ;;
    Linux)
        TargetFile=${1:-$RootPath/sdklib/libsdk.so}
        ;;
    *)
        echo "Unsupported platform"
        exit 0
        ;;
esac

[[ "-$GOPATH" == "-" ]] && { echo "GOPATH not set"; exit 1; }

LDFlags="-X github.com/chubaofs/chubaofs/proto.Version=${Version} \
    -X github.com/chubaofs/chubaofs/proto.CommitID=${CommitID} \
    -X github.com/chubaofs/chubaofs/proto.BranchName=${BranchName} \
    -X 'github.com/chubaofs/chubaofs/proto.BuildTime=${BuildTime}' "

go build \
    -ldflags "${LDFlags}" \
    -buildmode c-shared \
    -o $TargetFile \
    ${SrcPath}/*.go
