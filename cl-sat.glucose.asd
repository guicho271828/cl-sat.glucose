#|
  This file is a part of cl-sat.glucose project.
  Copyright (c) 2016 Masataro Asai (guicho2.71828@gmail.com)
|#

#|
  CL-SAT instance to Glucose state-of-the-art SAT solver.
  This downloads the later 2014 version (2nd in the competition).

  Author: Masataro Asai (guicho2.71828@gmail.com)
|#



(in-package :cl-user)
(defpackage cl-sat.glucose-asd
  (:use :cl :asdf))
(in-package :cl-sat.glucose-asd)


(defsystem cl-sat.glucose
  :version "0.1"
  :author "Masataro Asai"
  :mailto "guicho2.71828@gmail.com"
  :homepage "http://www.labri.fr/perso/lsimon/glucose/"
  :bug-tracker "https://github.com/guicho271828/cl-sat.glucose/issues"
  :source-control (:git "https://github.com/guicho271828/cl-sat.glucose.git")
  :license "LLGPL"
  :depends-on (:trivia :alexandria :iterate :cl-sat :trivial-package-manager)
  :components ((:module "src"
                :components
                ((:file "package"))))
  :description "CL-SAT instance to Glucose state-of-the-art SAT solver. This downloads the later 2014 version (2nd in the 2014 SAT competition)."
  :in-order-to ((test-op (test-op :cl-sat.glucose.test)))
  :defsystem-depends-on (:trivial-package-manager)
  :perform
  (load-op :before (op c)
           (uiop:symbol-call :trivial-package-manager
                             :ensure-program
                             "glucose"
                             :from-source (format nil "make -C ~a"
                                                  (asdf:system-source-directory :cl-sat.glucose)))))
