#lang racket/base
;; Plain Racket version, using (require) instead of #lang marketplace.

(require marketplace/sugar)
(require marketplace/drivers/tcp-bare)

(define (echoer from to)
  (transition/no-state
    (publisher (tcp-channel to from ?))
    (subscriber (tcp-channel from to ?)
      (on-absence (quit))
      (on-message
       [(tcp-channel _ _ data)
	(send-message (tcp-channel to from data))]))))

(ground-vm tcp
	   (observe-publishers (tcp-channel ? (tcp-listener 5999) ?)
	     (match-conversation (tcp-channel from to _)
	       (on-presence (spawn (echoer from to))))))
