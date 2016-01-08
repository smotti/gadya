#lang racket
(require 2htdp/batch-io)

;; Write down notes damnit!!!
;; - Tried regex, the solution is certainly shorter and we get the name of the scrap and content for free
;;   but we cannot (or it's very hard) parse nested scraps in this way.
;; - The new approach sees the file's content as a tree and walks it, as soon a scrap is discovered we walk
;;   the scrap and get its lines. Though we still don't catch nested scraps.

(define code (read-lines "/tmp/test.go"))
(define comment-string "//")

(define scrap-begin (pregexp (string-append "^\\s?" comment-string "@begin\\s+([-\\w]+)$")))
(define scrap-end (pregexp (string-append "^(\\s?|[})\\]])\\s?" comment-string "@end$")))

; Get the scrap-name from a scrap-begin match.
(define (scrap-name line)
  (caar (regexp-match* scrap-begin line #:match-select cdr)))

; Take the rest of the code and keep walking until scrap-end.
(define (walk-scrap code)
  (let ((scrap '()))
    (define (walk code scrap)
      (let ((line (first code)))
        ;(printf "Inspect line: ~a~n" line)
        ;(printf "Scrap looks like this so far: ~a~n" scrap)
        (cond
          [(regexp-match? scrap-end line) scrap]
          [(not (regexp-match? scrap-end line)) (begin
                                                  ;(printf "Append line to scrap: ~a~n" line)
                                                  (walk (rest code) (append scrap (list line))))])))
    (walk code scrap)))

; Walk the code and if we hit scrap-begin walk-scrap.
(define (walk-code code scraps)
  (cond
    [(empty? code) scraps]
    [(and (not (empty? code))
          (regexp-match? scrap-begin (first code))) (begin
                                                      (printf "Found scrap: ~a~n" (first code))
                                                      (walk-code (rest code ) (if (empty? scraps)
                                                                                  (append scraps (walk-scrap (rest code)))
                                                                                  (cons scraps (list (walk-scrap (rest code)))))))]
    [(not (empty? code)) (walk-code (rest code) scraps)]))


