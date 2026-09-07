import os

const slice_multi_return_vexe = @VEXE
const slice_multi_return_tests_dir = os.dir(@FILE)
const slice_multi_return_v3_dir = os.dir(slice_multi_return_tests_dir)
const slice_multi_return_vlib_dir = os.dir(slice_multi_return_v3_dir)
const slice_multi_return_v3_src = os.join_path(slice_multi_return_v3_dir, 'v3.v')

fn test_slice_multi_return_uses_complete_c_type_name() {
	v3_bin := os.join_path(os.temp_dir(), 'v3_slice_multi_return_test_${os.getpid()}')
	os.rm(v3_bin) or {}
	build := os.execute('"${slice_multi_return_vexe}" -cc tcc -gc none -path "${slice_multi_return_vlib_dir}|@vlib|@vmodules" -o "${v3_bin}" "${slice_multi_return_v3_src}"')
	assert build.exit_code == 0, build.output

	project := os.join_path(os.temp_dir(), 'v3_slice_multi_return_${os.getpid()}')
	module_dir := os.join_path(project, 'values')
	os.mkdir_all(module_dir) or { panic(err) }
	os.write_file(os.join_path(module_dir, 'values.v'), 'module values

pub fn get() ([]string, int) {
	return [\'x\'], 1
}
') or { panic(err) }
	os.write_file(os.join_path(project, 'main.v'), 'module main

import values

fn main() {
	items, n := values.get()
	assert items == [\'x\']
	assert n == 1
}
') or { panic(err) }
	bin := os.join_path(os.temp_dir(), 'v3_slice_multi_return_${os.getpid()}')
	compile := os.execute('"${v3_bin}" -keepc "${project}" -o "${bin}"')
	assert compile.exit_code == 0, compile.output
	run := os.execute('"${bin}"')
	assert run.exit_code == 0, run.output
	generated := os.read_file(bin + '.c') or { panic(err) }
	assert generated.contains('multi_return_Array_i64 __multi_ret_'), generated
	assert !generated.contains('_Array_ __multi_ret_'), generated
}
