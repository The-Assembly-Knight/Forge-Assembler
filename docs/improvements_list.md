# Improvements for Tokenizer

## General

- [ ] Reduce the use of general purpose registers.
- [ ] Avoid the constant use of global labels (whenever is possible).

## Functionality/Performance

- [ ] Give scanner and classifier an input and output through registers, as if they were functions.
- [ ] Replace multiple byte comparasions for a look-up table and bt & jc.
- [ ] Change the classifying tables for a single table.
- [ ] Define a common data struct between the scanner and the classifier to avoid problems related to registers' use.
- [ ] Extract the use of many labels and jmps into single labels and calls.
- [ ] Start using macros whenever possible to reduce the amount of repeated code.

## Debugging or bug preventor

- [ ] Start using DWARF debugging labels throughout the entire code.
- [ ] Check input_buffer bounds, and in case it surpasses its MAX_SIZE cancel the program with an error message.
- [ ] Start naming labels with . if they are private.
- [ ] Find better (or more general) names for some labels.
- [ ] Improve comments throughout the code.
- [ ] Modulirize the entire project

## Definitions

- [ ] No magic numbers anymore, start defining everything as constants.
- [x] Create defs files, where definitions will be stored and globalized.
- [ ] Separate defs into multiple files with a common purpose.

