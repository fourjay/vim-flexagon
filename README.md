# Vim fold method manipulation tool

A wrapper around vims folding to easily switch between various folding schemes.

There is one command **''Fold:''** which takes a fold method argument.

Currently supported folding arguments:

   * wiki
     Fold on comment strings in a wiki style hierarchy, with
     # =
     # ==
     # ===
   * space
     space separated sections (i.e. "paragraphs")
   * comment
   * braces
   * code
   * manual
   * indent
   * html
   * header
     "Flower Pot" headers (not particularly sophisticated)


