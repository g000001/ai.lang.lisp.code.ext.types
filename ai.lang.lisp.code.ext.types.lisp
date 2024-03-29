;;;; ai.lang.lisp.code.ext.types.lisp

(cl:in-package :ai.lang.lisp.code.ext.types)

;;; Written by
; Fernando D. Mato Mira				
; Computer Graphics Lab                         	
; Swiss Federal Institute of Technology (EPFL)	Phone    : +41 (21) 693 - 5248
; CH-1015 Lausanne				FAX      : +41 (21) 693 - 5328
; Switzerland					E-mail   : matomira@di.epfl.ch

; Received 19-NOV-93 22:07:56 by Mark Kantrowitz

;
;  Due to a coerce bug in ACL [(coerce 0 '(AND T FLOAT) raises an error],
;  I had to implement a type specifier simplification routine.
;  Not that it is proved to be optimal, but `something is something'
;  (in Spanish we say like that)..

(defun simplify-type (typ)
  (cond ((atom typ) typ)
	((eq (car typ) 'or)  (simplify-or-type-specifier typ))
	((eq (car typ) 'and) (simplify-and-type-specifier typ))
	(t typ)))

(defun simplify-unary-type-combination (typ)
  (let ((sub (cadr typ)))
    (if (atom sub)
	sub
      (simplify-type sub))))

(defun simplify-and-type-specifier (typ)
  (if (eql (length typ) 2)
      (simplify-unary-type-combination typ)
    (let ((spec1 (simplify-type (cadr typ)))
	  (spec2 (simplify-type (cons 'and (cddr typ)))))
      (cond ((subtypep spec1 spec2)          spec1)
	    ((subtypep spec2 spec1)          spec2)
	    ((or (null spec1) (null spec2))  nil)
	    ((atom spec1)
	     (cond ((atom spec2)            `(and ,spec1 ,spec2))
		   ((eq (car spec2) 'and)    (list* 'and spec1 (cdr spec2)))
		   (t                       `(and ,spec1 ,spec2))))
	    ((atom spec2)
	     (cond ((eq (car spec1) 'and)    (list* 'and spec2 (cdr spec1)))
		   (t                       `(and ,spec1 ,spec2))))
	    ((and (eq (car spec1) 'and)
		  (eq (car spec2) 'and))     (cons 'and (append (cdr spec1) (cdr spec2))))
	    (t `(and ,spec1 ,spec2))))))

(defun simplify-or-type-specifier (typ)
 (if (eql (length typ) 2)
     (simplify-unary-type-combination typ)
   (let ((spec1 (simplify-type (cadr typ)))
	 (spec2 (simplify-type (cons 'or (cddr typ)))))
     (cond ((subtypep spec1 spec2)          spec2)
	   ((subtypep spec2 spec1)          spec1)
	   ((null spec1)                    spec2)
	   ((null spec2)                    spec1)
	   ((atom spec1)
	    (cond ((atom spec2)            `(or ,spec1 ,spec2))
		  ((eq (car spec2) 'or)     (list* 'or spec1 (cdr spec2)))
		  (t                       `(or ,spec1 ,spec2))))
	   ((atom spec2)
	    (cond ((eq (car spec1) 'or)     (list* 'or spec2 (cdr spec1)))
		  (t                       `(or ,spec1 ,spec2))))
	   ((and (eq (car spec1) 'or)
		 (eq (car spec2) 'or))     (cons 'or (append (cdr spec1) (cdr spec2))))
	   (t `(or ,spec1 ,spec2))))))

;;; *EOF*

