# mdbook_vpreprocessor

1. Turns MDBook json string into MDBook structs in Vlang.
2. Delivers Book struct to process.
3. Encodes and outputs processed book to MDBook compiler.

## To Run

```
mdbook build
```

## To Process

Add your processing function where some_process() is, and pass in mut book.

```
fn main() {
    ...

	// add processor here, mutate book
	some_process(mut &book)

	...
}
```

## Test

The test function attempts to decode the entire stringified MDBook array into an array of PreprocessorContext and Book sum type array, however fails to do so.

Left in code to look into it.
