#lang racket
(require 2htdp/batch-io)

(define code "/home/sarala/Programming/lp/gadya/example.go")
(define doc "/home/sarala/Programming/lp/gadya/example_doc.tex")
(define comment-char "//")

; Read the code file line by line.
(define mem-code (read-words/line code))

; A hash-table to store scraps by name.
(define scraps (make-hash))

; Parsing the code file. Can we do that recursive by passing the rest of the code? How to store a scrap?
; If we first encounter a scrap with a name we have to keep going until we find the next @scrap without a name.
; But how to do that if we do it recursively.
(define (parse-code code))
  