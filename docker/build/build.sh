#!/bin/bash

base='x86'
tag_name='bitcoinnanolabs/btco-build:latest'
docker_file='Dockerfile.build'

print_usage() {
	echo 'build.sh [-h] [-b {x86|arm}]'
}

while getopts 'hb:' OPT; do
	case "${OPT}" in
		h)
			print_usage
			exit 0
			;;
		b)
			base="${OPTARG}"
			;;
		*)
			print_usage >&2
			exit 1
			;;
	esac
done

case "${base}" in
	x86)
		;;
	arm)
        tag_name='bitcoinnanolabs/btco-build:arm'
        docker_file='Dockerfile.build-arm'
		;;
	*)
		echo "Invalid base: ${base}" >&2
		exit 1
		;;
esac

REPO_ROOT=`git rev-parse --show-toplevel`
pushd $REPO_ROOT
docker build --no-cache -f docker/build/$docker_file -t $tag_name .
popd
