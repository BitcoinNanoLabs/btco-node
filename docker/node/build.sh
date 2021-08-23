#!/bin/bash

network='live'
base='x86'
arm_tag=''
docker_file='Dockerfile'

print_usage() {
	echo 'build.sh [-h] [-n {live|beta|test}] [-b {x86|arm}]'
}

while getopts 'hn:b:' OPT; do
	case "${OPT}" in
		h)
			print_usage
			exit 0
			;;
		n)
			network="${OPTARG}"
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

case "${network}" in
	live)
		network_tag=''
		;;
	test|beta)
		network_tag="-${network}"
		;;
	*)
		echo "Invalid network: ${network}" >&2
		exit 1
		;;
esac

case "${base}" in
	x86)
		;;
	arm)
		arm_tag="-arm"
		docker_file="Dockerfile-arm"	
		;;
	*)
		echo "Invalid base: ${base}" >&2
		exit 1
		;;
esac

REPO_ROOT=`git rev-parse --show-toplevel`
COMMIT_SHA=`git rev-parse --short HEAD`
pushd $REPO_ROOT
docker build --no-cache --build-arg NETWORK="${network}" -f docker/node/${docker_file} -t bitcoinnanolabs/btco${network_tag}:latest${arm_tag}  .
popd
