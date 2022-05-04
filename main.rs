extern crate docopt;
extern crate mdbook;
extern crate serde_json;
#[macro_use]
extern crate serde_derive;
extern crate serde;
#[macro_use]
extern crate log;
extern crate chrono;
extern crate env_logger;

use chrono::Local;
use docopt::Docopt;
use env_logger::Builder;
use log::LevelFilter;
use mdbook::{
    book::{Book, BookItem},
    errors::{Error, Result as MdResult},
    preprocess::{CmdPreprocessor, Preprocessor, PreprocessorContext},
};
use std::env;
static USAGE: &str = "
Usage:
    mdbook-presentation-preprocessor
    mdbook-presentation-preprocessor supports <supports>
";

#[derive(Deserialize)]
struct Args {
    pub arg_supports: Option<String>,
}

fn main() -> MdResult<()> {
    init_logging();
    let args: Args = Docopt::new(USAGE)
        .and_then(|a| a.deserialize())
        .unwrap_or_else(|e| e.exit());
    info!("Running presentation preprocessor");
    let pre = WrapPresentation;
    if let Some(ref arg) = args.arg_supports {
        debug!("just getting support info {:?}", arg);
        if pre.supports_renderer(arg) {
            ::std::process::exit(0);
        } else {
            ::std::process::exit(1);
        }
    }
    debug!("pre-processing");
    let (ctx, book) = CmdPreprocessor::parse_input(::std::io::stdin())?;
    let processed_book = pre.run(&ctx, book)?;
    serde_json::to_writer(::std::io::stdout(), &processed_book)?;
    Ok(())
}

struct WrapPresentation;

impl Preprocessor for WrapPresentation {
    fn name(&self) -> &str {
        NAME
    }

    fn run(&self, _ctx: &PreprocessorContext, mut book: Book) -> Result<Book, Error> {
        debug!("Wrapping presentation only items with a div");
        //process_chapters(&mut book.sections)?;
        Ok(book)
    }

    fn supports_renderer(&self, renderer: &str) -> bool {
        match renderer {
            "html" => true,
            _ => false,
        }
    }
}