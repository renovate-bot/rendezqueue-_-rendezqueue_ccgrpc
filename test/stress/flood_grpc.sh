#!/bin/sh

set -e

n=$1
test -n "$n"
n=$(($n / 3))

process_count=$2
if [ -z "${process_count}" ]; then
  process_count=10
fi

count_per_process=$((($n + ${process_count} - 1) / ${process_count}))
n=$(($count_per_process * ${process_count}))

printf 'Sending %u * %u processes * 3 phases == %u requests\n' \
  ${count_per_process} ${process_count} $((3 * $n))

xargs_cmd="xargs -n 1 -P ${process_count} ./bazel-bin/src/ccgrpc/syncclient --count ${count_per_process}"

seq 1 "${process_count}" |
${xargs_cmd} --id Alice --key >/dev/null 2>&1

seq 1 "${process_count}" |
${xargs_cmd} --id Bob --key >/dev/null 2>&1

seq 1 "${process_count}" |
${xargs_cmd} --id Alice --key >/dev/null 2>&1

