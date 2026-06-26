#!/usr/bin/env bats

# Real-application pressure test using the official nginx image.

load ../helpers/common.bash

@test "nginx hook fixture starts as remapped non-root user" {
  local -a lines

  run docker run --rm \
    -e NGINX_UID=1234 \
    -e NGINX_GID=2345 \
    -e NGINX_USER=webapp \
    -e NGINX_HOME=/home/webapp \
    "${TEST_NGINX_IMAGE}" \
    sh -lc '
      nginx -t >/dev/null
      nginx -g "daemon off;" &
      pid="$!"
      sleep 1
      printf "%s\n%s\n%s\n%s\n%s\n" "$(id -u)" "$(id -g)" "$(id -un)" "$HOME" "$(stat -c "%u:%g" /tmp/nginx.pid)"
      kill -TERM "$pid"
      wait "$pid"
    '
  [ "$status" -eq 0 ]
  mapfile -t lines <<<"${output}"
  assert_output_eq "1234" "${lines[0]}" "nginx fixture uid mismatch"
  assert_output_eq "2345" "${lines[1]}" "nginx fixture gid mismatch"
  assert_output_eq "webapp" "${lines[2]}" "nginx fixture user mismatch"
  assert_output_eq "/home/webapp" "${lines[3]}" "nginx fixture home mismatch"
  assert_output_eq "1234:2345" "${lines[4]}" "nginx fixture pid ownership mismatch"
}
