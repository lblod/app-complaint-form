(in-package :mu-cl-resources)

;;;;
;; NOTE
;; docker-compose stop; docker-compose rm; docker-compose up
;; after altering this file.

(read-domain-file "master-files-domain.lisp")
(read-domain-file "master-email-domain.lisp")
(read-domain-file "master-form-domain.lisp")
(read-domain-file "master-users-domain.lisp")

(defparameter *include-count-in-paginated-responses* t)