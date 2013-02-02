(cl:in-package :ai.lang.lisp.code.ext.types)

(def-suite ai.lang.lisp.code.ext.types)

(in-suite ai.lang.lisp.code.ext.types)


(test simplify 
  (is-true (eq (simplify-type '(AND cl:simple-string  cl:vector))
               'simple-string))
  (is-true (eq (simplify-type '(AND cl:simple-string  cl:string))
               'SIMPLE-STRING))
  (is-true (eq (simplify-type '(or cl:simple-string  cl:string))
               'string))
  (is-true (eq (simplify-type '(and cl:simple-string  cl:string (cl:string 8)))
               '(and simple-string (string 8)))))

