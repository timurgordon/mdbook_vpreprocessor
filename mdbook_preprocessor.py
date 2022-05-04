# used to demonstrate preprocessing works in python

from cmath import log
import json
import sys

if __name__ == '__main__':
    if len(sys.argv) > 1:  # we check if we received any argument
        if sys.argv[1] == "supports":
            # then we are good to return an exit status code of 0, since the other argument will just be the renderer's name
            sys.exit(0)
    context, book = json.load(sys.stdin)
    #print(context, book)
    book['sections'][0]['Chapter']['content'] = '# Helloooo'
    print(json.dumps(book))
