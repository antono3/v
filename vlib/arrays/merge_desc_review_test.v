module arrays

struct MergeDescItem {
	key int
	tag string
}

fn (a MergeDescItem) < (b MergeDescItem) bool {
	return a.key < b.key
}

fn test_merge_desc_with_strings() {
	assert merge_desc(['z', 'm', 'a'], ['y', 'm', 'b']) == ['z', 'y', 'm', 'm', 'b', 'a']
}

fn test_merge_desc_custom_comparison_is_stable_on_equal_keys() {
	a := [MergeDescItem{3, 'a3'}, MergeDescItem{2, 'a2'}, MergeDescItem{1, 'a1'}]
	b := [MergeDescItem{3, 'b3'}, MergeDescItem{2, 'b2'}, MergeDescItem{0, 'b0'}]
	merged := merge_desc(a, b)
	assert merged.map(it.tag) == ['a3', 'b3', 'a2', 'b2', 'a1', 'b0']
}
