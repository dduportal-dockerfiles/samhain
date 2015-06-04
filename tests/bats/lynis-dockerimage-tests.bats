#!/usr/bin/env bats

@test "Samhain is installed" { 
	docker run "${DOCKER_IMAGE_NAME}"
}

SAMHAIN_VERSION=3.1.5
@test "The installed version of samhain is ${SAMHAIN_VERSION}" {
	FOUND_VERSION=$(docker run "${DOCKER_IMAGE_NAME}" --version 2>/dev/null | grep 'This is samhain' | cut -d'(' -f2 | cut -d')' -f1)
	[ "${FOUND_VERSION}" == "${SAMHAIN_VERSION}" ]
}

CENTOS_VERSION=7.1
@test "We use the alpine linux version ${ALPINE_VERSION}" {
 	[ $(docker run --entrypoint sh "${DOCKER_IMAGE_NAME}" -c "grep VERSION_ID /etc/os-release | grep -e \"=${ALPINE_VERSION}.\" | wc -l") -eq 1 ]
}

@test "Bash is installed" {
	docker run --entrypoint sh "${DOCKER_IMAGE_NAME}" -c "which bash"
}

@test "Tar is installed" {
	docker run --entrypoint sh "${DOCKER_IMAGE_NAME}" -c "which tar"
}

@test "OpenSSL is installed" {
	docker run --entrypoint sh "${DOCKER_IMAGE_NAME}" -c "which openssl"
}

@test "Curl is installed" {
	docker run --entrypoint sh "${DOCKER_IMAGE_NAME}" -c "which curl"
}

@test "GPG is installed" {
	docker run --entrypoint sh "${DOCKER_IMAGE_NAME}" -c "which gpg"
}

@test "GCC is not installed" {
	run docker run --entrypoint sh "${DOCKER_IMAGE_NAME}" -c "which gcc"
	[ "$status" -ne 0 ]
}


@test "We have loaded the GPG key of Samhain" {
	[ $(docker run --entrypoint sh "${DOCKER_IMAGE_NAME}" -c "gpg --list-keys 2>/dev/null | grep 0F571F6C | wc -l") -eq 1 ]
}
