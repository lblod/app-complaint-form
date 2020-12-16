(in-package :mu-cl-resources)

;;;;
;; NOTE
;; docker-compose stop; docker-compose rm; docker-compose up
;; after altering this file.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; KLACHTENFORMULIEREN ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-resource complaint-form ()
  :class (s-prefix "ext:ComplaintForm")
  :properties `((:name :string ,(s-prefix "foaf:name"))
                (:contact-person-name :string ,(s-prefix "ext:personName"))
                (:street :string ,(s-prefix "schema:streetAddress"))
                (:house-number :number ,(s-prefix "schema:postOfficeBoxNumber"))
                (:address-complement :string ,(s-prefix "ext:addressComplement"))
                (:locality :string ,(s-prefix "schema:addressLocality"))
                (:postal-code :number ,(s-prefix "schema:postalCode"))
                (:telephone :string ,(s-prefix "schema:telephone"))
                (:email :string ,(s-prefix "schema:email"))
                (:content :string ,(s-prefix "ext:content"))
                (:created :datetime ,(s-prefix "dct:created"))
                (:is-converted-to-email :string ,(s-prefix "ext:isConvertedIntoEmail")))
  :has-many `((file :via ,(s-prefix "nmo:hasAttachment")
                    :as "attachments"))
  :resource-base (s-url "http://data.lblod.info/complaint-forms/")
  :on-path "complaint-forms")