module main

// module of v mdbook structs
// ignore vls errors, module has types
import mdbook { Book, PreprocessorContext }
import json
import os

type ObjectSumType = Book | PreprocessorContext

fn main() {
	// checking if renderer supports
	if os.args.len > 1 {
		if os.args[1] == 'supports' {
			exit(0)
		}
	}

	// receives, parses and decodes json str into MDBook:Book
	mdbook_str := os.get_lines()[0]
	book_str := json_split_array(&mdbook_str)[1]
	mut book := json.decode(Book, book_str) or { panic('error $err') }

	// add processor here, mutate book
	some_process(mut &book)

	// outputs processed book to compile
	println(json.encode(&book)#[..-1] + ',"__non_exhaustive":null}')
}

// example process
fn some_process(mut book Book) {
	for mut section in book.sections {
		section.chapter.content += ' :)'
	}
}

// gets stringified array, returns array of stringified structs
fn json_split_array(file_str string) []string {
	tokens := ['[', '{']
	mut token_buf := []u8{}

	for i, char in file_str[1..] {
		if token_buf.len == 0 && char.ascii_str() == ',' {
			// found array separation
			return [file_str[1..i + 1], file_str#[i + 2..-1]]
		} else if char.ascii_str() in tokens {
			// found opening bracket
			token_buf << char
		} else if char == token_buf.last() + 2 {
			// found closing bracket
			token_buf.pop()
		}
	}
	return [file_str]
}

// can't decode into array of sum type
fn test(file_str string) {
	// stdin; context and book strings are separated for testing
	mdbook_str := file_str // [PrerocessorContext, Book]
	ctx_str := json_split_array(&mdbook_str)[0]
	book_str := json_split_array(&mdbook_str)[1]

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

	// doesn't work
	decoded_mdbook := json.decode([]ObjectSumType, file_str) or {
		panic('error $err')
		return
	}

	processed_book := decoded_mdbook[1]
	encoded_book := json.encode(processed_book)#[..-1] + ',"__non_exhaustive":null}'
	println(encoded_book)
}
