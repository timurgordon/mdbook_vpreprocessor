module main

// module of v mdbook structs
// ignore vls errors, module has types
import json
import os
import mdbook { Book, PreprocessorContext }

type ObjectSumType = Book | PreprocessorContext

fn main() {
	// checking if renderer supports
	if os.args.len > 1 {
		if os.args[1] == 'supports' {
			exit(0)
		}
	}

	mut file := os.stdin()
	mut bufs := []u8{}
	file_str := bufs.bytestr()
	file.close()
	test(file_str)
}

// gets json array, retuurn
fn json_split_array(json_str string) {
	tokens := ['[', ']', '{', '}']
	token := ''
	for mut char in json_str {
		// if char.ascii_str() =
		if char in tokens {
			token = char
			println(char + 1)
		}
		println(char)
	}
}

// uncomment lines 51 or 54 to see decoding into array of sum type doesn't work
fn test(file_str string) {
	// stdin, context and book strings are separated for testing.
	ctx_str := '{"root":"/Users/timurgordon/development/threefold/playground/mdbook/mdbook-presentation-preprocessor/example","config":{"book":{"authors":["Robert Masen"],"language":"en","multilingual":false,"src":"src","title":"presentation-preprocessor-example"},"preprocessor":{"vpreprocessor":{"command":"cargo run"}}},"renderer":"html","mdbook_version":"0.4.18"}'
	book_str := '{"sections":[{"Chapter":{"name":"Chapter 1","content":"# An Interesting Thing\\n> Press `alt+p` to toggle which version is displayed.\\n> Open the console to see the notes printed there\\n\\nweb-only$\\nHere is a much longer explanation about what this\\ninteresting thing is and how interesting you might find it.\\n\\nTo elaborate, it is extremely interesting.\\nweb-only-end$\\n\\nslides-only$\\n## A list of things\\n- Fact one is intriguing\\n- Fact two is piquing my interest\\n- Fact three has me down right flabbergasted\\n- Fact four is almost obscene\\nslides-only-end$\\n\\nnotes$\\n- Don\'t for get to mention this\\n- And This\\n- And This\\nnotes-end$","number":[1],"sub_items":[],"path":"chapter_1.md","parent_names":[]}},{"Chapter":{"name":"Chapter 2","content":"# Another Interesting Thing\\n> Press `alt+p` to toggle which version is displayed.\\n> Open the console to see the notes printed there\\n\\nweb-only$\\nContinuing the explanation from earlier.\\n\\nThis is an elaboration on the very interesting\\nthings from the last page.\\nweb-only-end$\\n\\nslides-only$\\n## Another list of things\\n- Fact five is more intriguing\\n- Fact six is piquing my interest, further\\n- Fact seven has me down right shell-shocked\\n- Fact eight is obscene\\nslides-only-end$\\n\\nnotes$\\n- Pit-fall 1: stuff\\n- Pit-fall 2: other stuff\\nnotes-end$","number":[2],"sub_items":[],"path":"chapter_2.md","parent_names":[]}}],"__non_exhaustive":null}'
	mdbook_str := '[{"root":"/Users/timurgordon/development/threefold/playground/mdbook/mdbook-presentation-preprocessor/example","config":{"book":{"authors":["Robert Masen"],"language":"en","multilingual":false,"src":"src","title":"presentation-preprocessor-example"},"preprocessor":{"vpreprocessor":{"command":"cargo run"}}},"renderer":"html","mdbook_version":"0.4.18"}, {"sections":[{"Chapter":{"name":"Chapter 1","content":"# An Interesting Thing\\n> Press `alt+p` to toggle which version is displayed.\\n> Open the console to see the notes printed there\\n\\nweb-only$\\nHere is a much longer explanation about what this\\ninteresting thing is and how interesting you might find it.\\n\\nTo elaborate, it is extremely interesting.\\nweb-only-end$\\n\\nslides-only$\\n## A list of things\\n- Fact one is intriguing\\n- Fact two is piquing my interest\\n- Fact three has me down right flabbergasted\\n- Fact four is almost obscene\\nslides-only-end$\\n\\nnotes$\\n- Don\'t for get to mention this\\n- And This\\n- And This\\nnotes-end$","number":[1],"sub_items":[],"path":"chapter_1.md","parent_names":[]}},{"Chapter":{"name":"Chapter 2","content":"# Another Interesting Thing\\n> Press `alt+p` to toggle which version is displayed.\\n> Open the console to see the notes printed there\\n\\nweb-only$\\nContinuing the explanation from earlier.\\n\\nThis is an elaboration on the very interesting\\nthings from the last page.\\nweb-only-end$\\n\\nslides-only$\\n## Another list of things\\n- Fact five is more intriguing\\n- Fact six is piquing my interest, further\\n- Fact seven has me down right shell-shocked\\n- Fact eight is obscene\\nslides-only-end$\\n\\nnotes$\\n- Pit-fall 1: stuff\\n- Pit-fall 2: other stuff\\nnotes-end$","number":[2],"sub_items":[],"path":"chapter_2.md","parent_names":[]}}],"__non_exhaustive":null}]'

	// works
	decoded_ctx := json.decode(PreprocessorContext, ctx_str) or {
		panic('error $err')
		return
	}

	// works
	decoded_book := json.decode(Book, book_str) or {
		panic('error $err')
		return
	}

	// decoded_mdbook = [unknown sum type value, unknown sum type value]
	decoded_mdbook := json.decode([]ObjectSumType, mdbook_str) or {
		panic('error $err')
		return
	}
	// panic(decoded_mdbook[1]) // prints "unknown sum type value"

	json_split_array(mdbook_str)
	processed_book := decoded_book
	// processed_book := decoded_mdbook[1] // doesn't work

	// formatting for rust, must have __non_exhaustive at end.
	encoded_book := json.encode(processed_book)#[..-1] + ',"__non_exhaustive":null}'
	println(encoded_book)
}
