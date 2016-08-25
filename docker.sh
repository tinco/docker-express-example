set -e

export IMAGE_NAME=tinco/express-example
export RUN_BUILD="docker run -it --rm -v $PWD:/usr/src/app -w /usr/src/app tinco/alpine-build-node"
export TEST_COMMAND="./node_modules/mocha/bin/mocha test"

function run_image() {
	docker run -it --entrypoint /bin/sh $IMAGE_NAME -c $1
}

function build_image() {
	$RUN_BUILD npm install
	docker build -t $IMAGE_NAME .
}

function test_image() {
	# TODO does this exit if the tests fail?
	run_image $TEST_COMMAND
}

function check_git() {
	if [[ `git status --porcelain` ]]; then
		echo "Current working directory is dirty, run 'git status' for details."
		exit 1
	fi	

	if [[ `git branch --no-color|grep "*"|awk '{ print $2 }'` != $TAG ]]; then
		echo "Current branch is not $TAG, checkout and merge that branch before releasing."
		exit 1
	fi
}

function push() {
	git push
	docker tag $IMAGE_NAME $IMAGE_NAME:$TAG
	docker push $IMAGE_NAME:$TAG
}

case "$1" in
	build)
		build_image
		;;
	test)
		$RUN_BUILD $TEST_COMMAND
		;;
	test_image)
		test_image
		;;
	release)
		export TAG=$2
		
		if  [ -z "$TAG" ]; then
			echo "Please supply the tag to be released (i.e. ./docker.sh release production)"
			exit 1
		fi

		build_image
		test_image
		check_git
		push
		;;
	install)
		shift
		$RUN_BUILD npm install --save "$@"
		;;
	*)
		echo "Usage: ./docker.sh <command>"
		echo ""
		echo "For <command> choose any of: build, test, test_image, install, release"	
esac

