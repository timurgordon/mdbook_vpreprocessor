module mdbook

pub struct PreprocessorContext {
pub:
	root           string
	config         Config
	renderer       string
	mdbook_version string
}

pub struct PathBuf {}

pub struct Config {
pub:
	book  BookConfig
	build BuildConfig
	rust  RustConfig
}

pub struct BookConfig {
pub:
	title        string
	authors      []string
	description  string
	src          string
	multilingual bool
	language     string
}

pub struct BuildConfig {
pub:
	build_dir                 string
	create_missing            bool
	use_default_preprocessors bool
}

struct RustConfig {
pub:
	edition RustEdition
}

pub enum RustEdition {
	e2021
	e2018
	e2015
}

pub struct Book {
pub mut:
	sections []BookItem
}

pub struct BookItem {
pub mut:
	chapter Chapter [json: Chapter]
	// part_title string [json: PartTitle]
}

pub struct Chapter {
pub mut:
	name         string
	content      string
	number       []u32
	sub_items    []BookItem
	path         string
	source_path  string
	parent_names []string
}

struct Separator {}
