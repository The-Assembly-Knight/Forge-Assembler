# Improvements for Tokenizer

- [ ] Reduce the use of general purpose registers.
- [ ] Avoid the constant use of global labels.
- [ ] Give scanner and classifier an input and output through registers, as if they were functions.
- [ ] Check input_buffer bounds, and in case it surpasses its MAX_SIZE cancel the program with an error message.
- [ ] Start using DWARF debugging labels throughout the entire code.
- [ ] Replace multiple byte comparasions for a look-up table and bt & jc
- [ ] No magic numbers anymore, start defining everything as constants.
- [ ] Start naming labels with . if they are private.
- [ ] Find better (or more general) names for some labels.
- [ ] Change the classifying tables for a single table.
- [ ] Define a common data struct between the scanner and the classifier to avoid problems related to registers' use.
- [ ] Extract the use of many labels and jmps into single labels and calls.
- [ ] Improve comments throughout the code.
