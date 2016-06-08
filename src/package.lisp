#|
  This file is a part of cl-sat.glucose project.
  Copyright (c) 2016 Masataro Asai (guicho2.71828@gmail.com)
|#

(in-package :cl-user)
(defpackage cl-sat.glucose
  (:use :cl :trivia :alexandria :iterate :cl-sat))
(in-package :cl-sat.glucose)

;; blah blah blah.

(defvar *glucose-home* (asdf:system-relative-pathname :cl-sat.glucose.build "glucose-syrup/"))

(defun glucose-binary (&optional (*glucose-home* *glucose-home*))
  (merge-pathnames "simp/glucose_static" *glucose-home*))

(defmethod solve ((input pathname) (solver (eql :glucose)) &rest options)
  (with-temp (dir :directory t :template "glucose.XXXXXXXX")
    (let* ((command (format nil "cd ~a; ~a ~{~A~^ ~}~a ~a"
                            (namestring dir)
                            (namestring (glucose-binary))
                            options (namestring input) "result")))
      (format t "~&; ~a" command)
      (multiple-value-match (uiop:run-program command :output *standard-output* :error-output *error-output* :ignore-error-status t)
        ((_ _ 0)
         ;; indeterminite
         (values nil nil nil))
        ((_ _ 10)
         ;; sat
         (ematch (iter (for token in-file (format nil "~a/result" dir))
                       (collect token))
           (assignments
            (values
             (iter (for v in (sat-instance-variables *instance*))
                   (for a in assignments)
                   (when (plusp a) (collect v)))
             t t))))
        ((_ _ 20)
         ;; unsat
         (values nil nil t))))))
