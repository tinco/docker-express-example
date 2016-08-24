set -e

docker build -t express-example-build -f build.Dockerfile .
export RUN_BUILD="docker run -it --rm -v $PWD:/usr/src/app -w /usr/src/app express-example-build"

function build_production() {
	$RUN_BUILD npm install
	docker build -t tinco/express-example .
}

case "$1" in
	production)
		build_production
		;;
	test)
		build_production
		$RUN_BUILD npm test
		;;
	add_dependency)
		shift
		$RUN_BUILD npm install --save "$@"
		;;
	*)
		build_production
esac

