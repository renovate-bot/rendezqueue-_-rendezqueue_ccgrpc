load("@fildesh//tool/bazel:fildesh_test.bzl", "fildesh_test")
load("@rules_sxproto//sxproto:defs.bzl", "sxproto_data")

def rendezqueue_scenario_test(name):
  sxproto_data(
      name = name,
      src = name + ".sxpb",
      proto_message = "rendezqueue.TrySwapScenario",
      proto_deps = [":scenario_proto"],
      testonly = 1,
  )
  fildesh_test(
      name = name + "_ccgrpc_expect_test",
      srcs = ["//test/scenario:ccgrpc_expect.fildesh"],
      tool_by_alias = {
         "expect_test": "//test/scenario:ccgrpc_expect",
      },
      input_by_option = {
          "scenario_data": ":" + name,
      }
  )
