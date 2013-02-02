;;;; ai.lang.lisp.code.ext.types.asd -*- Mode: Lisp;-*- 

(cl:in-package :asdf)

(defsystem :ai.lang.lisp.code.ext.types
  :serial t
  :depends-on (:fiveam)
  :components ((:file "package")
               (:file "ai.lang.lisp.code.ext.types")
               (:file "test")))

(defmethod perform ((o test-op) (c (eql (find-system :ai.lang.lisp.code.ext.types))))
  (load-system :ai.lang.lisp.code.ext.types)
  (or (flet ((_ (pkg sym)
               (intern (symbol-name sym) (find-package pkg))))
         (let ((result (funcall (_ :fiveam :run) (_ :ai.lang.lisp.code.ext.types.internal :ai.lang.lisp.code.ext.types))))
           (funcall (_ :fiveam :explain!) result)
           (funcall (_ :fiveam :results-status) result)))
      (error "test-op failed") ))

