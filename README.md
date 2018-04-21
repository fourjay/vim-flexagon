# Flexagon, A Vim fold method method manager

A wrapper around vims folding to easily switch between various folding schemes 
and some useful pre-packaged schemes, all designed to be easily discovered and 
easily switched.

Flexagon also provides some custom fold presentation and a "bubble" Plug 
mapping to walk through folds.

# Overview

Vim offers several folding methods, each with trade-offs, none to my mind fully 
satisfying. Further, I've found folds useful for code visualization, a purpose 
that's not a primary aim of vim's folding method.

Rather then striving to find the perfect fold method, I decided to embrace the 
diversity and make it easy to add and change folding methods

# Inspiration

An interesting and short comment thread on Reddit, in particular user 
``/u/]interiot`` preference for using mediawiki syntax over vim's native 
folding
https://www.reddit.com/r/vim/comments/1hnh8v/question_what_foldmethod_are_you_guys_using_and/

Wiki header syntax is intuitive, natural and clean.
It also has a natural and unobtrusive way to signal levels.

Some other natural schemes along this line:

* Markdown

* Javadoc/Doxygen

* "Flower pot" header bars

# Visualization

Folding offers a way for a text based editor to visualize "shape". Selectively
hiding code offers a way to emphasize other code. Flexagon offers two several
folds that help visualize code structure:

* Hide comments ( ``:Fold: code`` )

* Hide non-comments ( ``:Fold: comments`` )

* Blank and or all whitespace lines ( ``:Fold: space`` )

Each offers a different emphasis on the code, which I've found surprisingly
revealing and useful.

# Levels

One level of folding offers most of the benefit of folding, as folding
visibility is binary (visible or not). There is benefit in several levels, but
each additional level offers less. In particular each higher level fold
requires working through more mental details Many of the packaged folds in
Flexagon are conceived and implemented with only one fold level in mind.

As in vim's native marker folds, multiple levels are likely better when
deliberate, as the higher levels are more likely to be related with each other.
For example, a layer 4 indent in one block may have no relationship to a layer
4 indent in another block, but the intent of a ``{{`` marker in one block most
likely is highly related to a ``{{`` in another block.

# Commands

There is one command **''Fold:''** (shadowing vim's native ``:fold`` commeand). 
It offers tab completion of the various folding methods.


## Custom Folds

Currently supported folding arguments:

* ***wiki*** Use embedded wiki ``=`` heading markers. Given this code:

         #!/usr/bin/perl
         # = this is a first level header
         some_code_here();
         # == this is a second level header
         some_more_code_here();
         # === this is a third level header
         even_more_code();

``:Fold wiki`` will create nested folds as indicated.

Leading comments are expected.
     
* ***markdown*** similar to wiki, but use hash header. Also works on regular
  markdown

* ***doxygen*** Not a true/full javadoc/doxygen fold, but a useful approximation.
  Fold when an extra comment character is present, i.e.:
  * ``/**`` in ``c``
  * ``##`` in shell, perl etc.
  * ``///`` ( or ``##``) in ``php``
Most of these expect ``commentstring`` to be set.

* ***space*** space separated sections (i.e. "paragraphs")
    Since spaces often separate "ideas" this Fold provides an overview of the 
    ideas in the code.

* ***comment*** hide code and show comments. This approximates "literate" code 
  (Donald Knuth's interesting idea). 

* ***code*** This is the inverse of comment above, showing only code. This is 
  useful in code with excess comments (yes this exists :-) )

* ***braces*** Fold on brace characters. I found this in Steve Losh's .vimrc 
  and immediately wondered why this wasn't a standard. It's a very good fit for 
  any C language family code, roughly the equivalent of ``indent`` as a python
  fold.

* **header** "Flower Pot" headers (not particularly sophisticated)

* ***ini*** fold on DOS INI section headers with second folds on breaks and 
  comments

* ***html*** A not entirely successful attempt to fold HTML

## Vim Native Folds
Since I've shadowed vim's native fold command it's only polite to allow 
switching to those native methods
* ***manual***
* ***indent***

# Discussion

Folding with more then one level deep is complicated, not only in 
implementation, but in conception. Syntax folding offers fine control, in a way 
the seems logical, but in practice this has not worked well for me. Let alone 
resource drag, my practical experience changing the fold level expects more 
knowledge of which folding level I want to see. One level is easy to 
understand, and two levels provides most of the utility.

