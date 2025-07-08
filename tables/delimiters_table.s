                                       # set constants from defs directly in this file:
                                       ## Delimiters
.set WHITE_SPACE       , 1
.set NEW_LINE          , 2
.set COMMENT_BEGINNING , 3
.set FILE_END          , 4
                                       ## Acceptable characters
.set REGULAR_CHAR, 100
.set DIGIT, 101
                                       ### Prefixes
.set LOCAL_LABEL_BEGINNING, 102
.set MEMORY_ACCESS, 104
.set NUMBER_BEGINNING, 107
                                       ### Subfixes
.set LABEL_END, 103
                                       ### Signs
.set CONCATENATIVE_CHAR, 200
.set PLUS              , 201
.set MINUS             , 202
.set MULTIPLICATION    , 202




.macro GLOBL_OBJ name                  # declare a global object, including its debugging symbols
  .globl \name
  .type \name, @object
.endm

.section .rodata

GLOBL_OBJ DELIMITERS_TABLE
DELIMITERS_TABLE:
  .byte FILE_END                       # 0   - null
  .byte REGULAR_CHAR                   # 1   - start of heading
  .byte REGULAR_CHAR                   # 2   - start of text
  .byte REGULAR_CHAR                   # 3   - end of text
  .byte REGULAR_CHAR                   # 4   - end of transmission
  .byte REGULAR_CHAR                   # 5   - enquiry
  .byte REGULAR_CHAR                   # 6   - acknowledge
  .byte REGULAR_CHAR                   # 7   - bell, alert
  .byte REGULAR_CHAR                   # 8   - backspace
  .byte WHITE_SPACE                    # 9   - horizontal tab
  .byte NEW_LINE                       # 10  - new line
  .byte REGULAR_CHAR                   # 11  - vertical tabulation
  .byte REGULAR_CHAR                   # 12  - form feed
  .byte REGULAR_CHAR                   # 13  - carriage return
  .byte REGULAR_CHAR                   # 14  - shift out
  .byte REGULAR_CHAR                   # 15  - shift in
  .byte REGULAR_CHAR                   # 16  - data link escape
  .byte REGULAR_CHAR                   # 17  - device control one (XON)
  .byte REGULAR_CHAR                   # 18  - device control two
  .byte REGULAR_CHAR                   # 19  - device control three (XOFF)
  .byte REGULAR_CHAR                   # 20  - device control four
  .byte REGULAR_CHAR                   # 21  - negative acknowledge
  .byte REGULAR_CHAR                   # 22  - synchronous idle
  .byte REGULAR_CHAR                   # 23  - end of transmission block
  .byte REGULAR_CHAR                   # 24  - cancel
  .byte REGULAR_CHAR                   # 25  - end of medium
  .byte REGULAR_CHAR                   # 26  - substitute
  .byte REGULAR_CHAR                   # 27  - escape
  .byte REGULAR_CHAR                   # 28  - file separator
  .byte REGULAR_CHAR                   # 29  - group separator
  .byte REGULAR_CHAR                   # 30  - record separator
  .byte REGULAR_CHAR                   # 31  - unit separator
  .byte WHITE_SPACE                    # 32  - white space
  .byte REGULAR_CHAR                   # 33  - exclamation mark
  .byte REGULAR_CHAR                   # 34  - double quotes 
  .byte NUMBER_BEGINNING               # 35  - number sign
  .byte REGULAR_CHAR                   # 36  - dollar
  .byte REGULAR_CHAR                   # 37  - per cent sign
  .byte REGULAR_CHAR                   # 38  - ampersand
  .byte REGULAR_CHAR                   # 39  - single quote
  .byte REGULAR_CHAR                   # 40  - open parenthesis
  .byte REGULAR_CHAR                   # 41  - close parenthesis
  .byte MULTIPLICATION                 # 42  - asterisk
  .byte PLUS                           # 43  - plus
  .byte REGULAR_CHAR                   # 44  - comma
  .byte MINUS                          # 45  - hyphen-minus
  .byte LOCAL_LABEL_BEGINNING          # 46  - period/dot
  .byte REGULAR_CHAR                   # 47  - slash
  .byte DIGIT                          # 48  - zero
  .byte DIGIT                          # 49  - one
  .byte DIGIT                          # 50  - two
  .byte DIGIT                          # 51  - three
  .byte DIGIT                          # 52  - four
  .byte DIGIT                          # 53  - five
  .byte DIGIT                          # 54  - six
  .byte DIGIT                          # 55  - seven
  .byte DIGIT                          # 56  - eight
  .byte DIGIT                          # 57  - nine
  .byte LABEL_END                      # 58  - colon
  .byte COMMENT_BEGINNING              # 59  - semicolon
  .byte REGULAR_CHAR                   # 60  - less than
  .byte REGULAR_CHAR                   # 61  - equals
  .byte REGULAR_CHAR                   # 62  - greater than
  .byte REGULAR_CHAR                   # 63  - question mark
  .byte MEMORY_ACCESS                  # 64  - at sign
  .byte REGULAR_CHAR                   # 65  - uppercase A
  .byte REGULAR_CHAR                   # 66  - uppercase B
  .byte REGULAR_CHAR                   # 67  - uppercase C
  .byte REGULAR_CHAR                   # 68  - uppercase D
  .byte REGULAR_CHAR                   # 69  - uppercase E
  .byte REGULAR_CHAR                   # 70  - uppercase F
  .byte REGULAR_CHAR                   # 71  - uppercase G
  .byte REGULAR_CHAR                   # 72  - uppercase H
  .byte REGULAR_CHAR                   # 73  - uppercase I
  .byte REGULAR_CHAR                   # 74  - uppercase J
  .byte REGULAR_CHAR                   # 75  - uppercase K
  .byte REGULAR_CHAR                   # 76  - uppercase L
  .byte REGULAR_CHAR                   # 77  - uppercase M
  .byte REGULAR_CHAR                   # 78  - uppercase N
  .byte REGULAR_CHAR                   # 79  - uppercase O
  .byte REGULAR_CHAR                   # 80  - uppercase P
  .byte REGULAR_CHAR                   # 81  - uppercase Q
  .byte REGULAR_CHAR                   # 82  - uppercase R
  .byte REGULAR_CHAR                   # 83  - uppercase S
  .byte REGULAR_CHAR                   # 84  - uppercase T
  .byte REGULAR_CHAR                   # 85  - uppercase U
  .byte REGULAR_CHAR                   # 86  - uppercase V
  .byte REGULAR_CHAR                   # 87  - uppercase W
  .byte REGULAR_CHAR                   # 88  - uppercase X
  .byte REGULAR_CHAR                   # 89  - uppercase Y
  .byte REGULAR_CHAR                   # 90  - uppercase Z
  .byte REGULAR_CHAR                   # 91  - opening bracket
  .byte REGULAR_CHAR                   # 92  - backslash
  .byte REGULAR_CHAR                   # 93  - closing bracket
  .byte REGULAR_CHAR                   # 94  - caret-circumflex
  .byte REGULAR_CHAR                   # 95  - underscore
  .byte REGULAR_CHAR                   # 96  - grave accent
  .byte REGULAR_CHAR                   # 97  - lowercase a
  .byte REGULAR_CHAR                   # 98  - lowercase b
  .byte REGULAR_CHAR                   # 99  - lowercase c
  .byte REGULAR_CHAR                   # 100 - lowercase d
  .byte REGULAR_CHAR                   # 101 - lowercase e
  .byte REGULAR_CHAR                   # 102 - lowercase f
  .byte REGULAR_CHAR                   # 103 - lowercase g
  .byte REGULAR_CHAR                   # 104 - lowercase h
  .byte REGULAR_CHAR                   # 105 - lowercase i
  .byte REGULAR_CHAR                   # 106 - lowercase j
  .byte REGULAR_CHAR                   # 107 - lowercase k
  .byte REGULAR_CHAR                   # 108 - lowercase l
  .byte REGULAR_CHAR                   # 109 - lowercase m
  .byte REGULAR_CHAR                   # 110 - lowercase n
  .byte REGULAR_CHAR                   # 111 - lowercase o
  .byte REGULAR_CHAR                   # 112 - lowercase p
  .byte REGULAR_CHAR                   # 113 - lowercase q
  .byte REGULAR_CHAR                   # 114 - lowercase r
  .byte REGULAR_CHAR                   # 115 - lowercase s
  .byte REGULAR_CHAR                   # 116 - lowercase t
  .byte REGULAR_CHAR                   # 117 - lowercase u
  .byte REGULAR_CHAR                   # 118 - lowercase v
  .byte REGULAR_CHAR                   # 119 - lowercase w
  .byte REGULAR_CHAR                   # 120 - lowercase x
  .byte REGULAR_CHAR                   # 121 - lowercase y
  .byte REGULAR_CHAR                   # 122 - lowercase z
  .byte REGULAR_CHAR                   # 123 - opening brace
  .byte REGULAR_CHAR                   # 124 - vertical bar
  .byte REGULAR_CHAR                   # 125 - closing brace
  .byte REGULAR_CHAR                   # 126 - equivalency sign - tilde
  .byte REGULAR_CHAR                   # 127 - delete
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
  .byte REGULAR_CHAR                   #
